import * as apigw from '@aws-cdk/aws-apigatewayv2'
import * as apigwIntegrations from '@aws-cdk/aws-apigatewayv2-integrations'
import * as cdk from '@aws-cdk/core'
import * as ec2 from '@aws-cdk/aws-ec2'
import * as ecs from '@aws-cdk/aws-ecs'
import * as events from '@aws-cdk/aws-events'
import * as eventsTargets from '@aws-cdk/aws-events-targets'
import * as lambda from '@aws-cdk/aws-lambda'
import * as rds from '@aws-cdk/aws-rds'
import * as s3 from '@aws-cdk/aws-s3'
import * as s3deployment from '@aws-cdk/aws-s3-deployment'
import * as dotenv from 'dotenv'
import * as path from 'path'
dotenv.config({ path: path.join(__dirname, '../../.env') })

export class CheckparamStack extends cdk.Stack {
  constructor(scope: cdk.Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props)

    const vpc = new ec2.Vpc(this, 'Vpc', {
      cidr: '10.0.0.0/16',
      natGateways: 0,
      maxAzs: 2,
      subnetConfiguration: [
        {
          cidrMask: 24,
          name: 'Public',
          subnetType: ec2.SubnetType.PUBLIC,
        }
      ]
    })

    const vpcSg = new ec2.SecurityGroup(this, 'VpcSg', { vpc })
    vpcSg.addIngressRule(ec2.Peer.anyIpv4(), ec2.Port.tcp(80))
    vpcSg.addIngressRule(ec2.Peer.ipv4(vpc.vpcCidrBlock), ec2.Port.allTraffic())

    const mysqlSg = new ec2.SecurityGroup(this, 'MySQLSG', { vpc })
    mysqlSg.addIngressRule(ec2.Peer.anyIpv4(), ec2.Port.tcp(3306))

    const mysql = new rds.DatabaseInstance(this, 'MySQL', {
      engine: rds.DatabaseInstanceEngine.mysql({ version: rds.MysqlEngineVersion.VER_5_7_31 }),
      instanceType: ec2.InstanceType.of(ec2.InstanceClass.T3, ec2.InstanceSize.MICRO),
      vpc,
      vpcSubnets: {
        subnetType: ec2.SubnetType.PUBLIC
      },
      securityGroups: [mysqlSg],
    })

    const bucket = new s3.Bucket(this, 'Bucket', {
      publicReadAccess: true,
      websiteIndexDocument: 'index.html'
    })
    new s3deployment.BucketDeployment(this, 'BucketDeployment', {
      sources: [s3deployment.Source.asset('./s3', { exclude: ['*.png'] })],
      destinationBucket: bucket,
      prune: false
    })

    const environment = {
      DB_HOST: mysql.instanceEndpoint.hostname,
      DB_USER: mysql.secret?.secretValueFromJson('username').toString()!,
      DB_PASSWORD: mysql.secret?.secretValueFromJson('password').toString()!,
      RAILS_MASTER_KEY: process.env.RAILS_MASTER_KEY!,
      SECRET_KEY_BASE: process.env.SECRET_KEY_BASE!,
      TWITTER_API_KEY: process.env.TWITTER_API_KEY!,
      TWITTER_API_SECRET: process.env.TWITTER_API_SECRET!
    }

    const handler = new lambda.DockerImageFunction(this, 'Handler', {
      code: lambda.DockerImageCode.fromImageAsset('../', {
        target: 'handler'
      }),
      timeout: cdk.Duration.seconds(30),
      retryAttempts: 0,
      memorySize: 256,
      environment,
      logRetention: 1,
    })
    handler.currentVersion.addAlias('production', {
      provisionedConcurrentExecutions: 1
    })

    const updater = new lambda.DockerImageFunction(this, 'Updater', {
      code: lambda.DockerImageCode.fromImageAsset('../', {
        target: 'updater',
        entrypoint: ['/bin/sh', '-c'],
        cmd: ['bin/rails update:items']
      }),
      reservedConcurrentExecutions: 1,
      timeout: cdk.Duration.seconds(900),
      retryAttempts: 0,
      memorySize: 256,
      environment,
    })
    new events.Rule(this, 'ScheduledEvent', {
      schedule: events.Schedule.cron({
        minute: '0',
        hour: '5',
        weekDay: 'WED',
      }),
      targets: [
        new eventsTargets.LambdaFunction(updater),
      ]
    })

    const httpApi = new apigw.HttpApi(this, 'HttpAPI', {
      defaultIntegration: new apigwIntegrations.LambdaProxyIntegration({
        handler,
        payloadFormatVersion: apigw.PayloadFormatVersion.VERSION_2_0
      })
    })
    httpApi.addRoutes({
      integration: new apigwIntegrations.HttpProxyIntegration({ url: `${bucket.bucketWebsiteUrl}/favicon.ico` }),
      path: '/favicon.ico',
      methods: [apigw.HttpMethod.GET]
    })
    httpApi.addRoutes({
      integration: new apigwIntegrations.HttpProxyIntegration({ url: `${bucket.bucketWebsiteUrl}/apple-touch-icon.png` }),
      path: '/apple-touch-icon.png',
      methods: [apigw.HttpMethod.GET]
    })
    httpApi.addRoutes({
      integration: new apigwIntegrations.HttpProxyIntegration({ url: `${bucket.bucketWebsiteUrl}/assets/{proxy}` }),
      path: '/assets/{proxy}',
      methods: [apigw.HttpMethod.GET]
    })
    httpApi.addRoutes({
      integration: new apigwIntegrations.HttpProxyIntegration({ url: `${bucket.bucketWebsiteUrl}/icons/{proxy}` }),
      path: '/icons/{proxy}',
      methods: [apigw.HttpMethod.GET]
    })

    // const pmaTask = new ecs.FargateTaskDefinition(this, 'PMATask')
    // pmaTask.addContainer('PMAContainer', {
    //   image: ecs.ContainerImage.fromRegistry('phpmyadmin'),
    //   environment: {
    //     PMA_HOSTS: mysql.instanceEndpoint.hostname,
    //     UPLOAD_LIMIT: '2G'
    //   }
    // })
    // new ecs.FargateService(this, 'PMAService', {
    //   cluster: new ecs.Cluster(this, 'Checkparam', { vpc }),
    //   taskDefinition: pmaTask,
    //   assignPublicIp: true,
    //   platformVersion: ecs.FargatePlatformVersion.VERSION1_4,
    //   securityGroups: [vpcSg]
    // })
  }
}
