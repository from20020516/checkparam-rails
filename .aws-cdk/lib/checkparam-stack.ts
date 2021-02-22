import * as apigw from '@aws-cdk/aws-apigatewayv2'
import * as apigwIntegrations from '@aws-cdk/aws-apigatewayv2-integrations'
import * as cdk from '@aws-cdk/core'
import * as ec2 from '@aws-cdk/aws-ec2'
import * as ecs from '@aws-cdk/aws-ecs'
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
      natGateways: 1,
      maxAzs: 2,
      subnetConfiguration: [
        {
          cidrMask: 24,
          name: 'Public',
          subnetType: ec2.SubnetType.PUBLIC,
        },
        {
          cidrMask: 24,
          name: 'Private',
          subnetType: ec2.SubnetType.PRIVATE,
        },
        {
          cidrMask: 24,
          name: 'Isolated',
          subnetType: ec2.SubnetType.ISOLATED,
        }
      ]
    })

    const vpcSg = new ec2.SecurityGroup(this, 'VpcSg', { vpc })
    vpcSg.addIngressRule(ec2.Peer.anyIpv4(), ec2.Port.tcp(80))
    vpcSg.addIngressRule(ec2.Peer.ipv4(vpc.vpcCidrBlock), ec2.Port.allTraffic())

    const aurora = new rds.ServerlessCluster(this, 'AuroraServerless', {
      engine: rds.DatabaseClusterEngine.auroraMysql({ version: rds.AuroraMysqlEngineVersion.VER_5_7_12 }),
      defaultDatabaseName: 'checkparam',
      scaling: {
        maxCapacity: 1,
        minCapacity: 1,
        autoPause: cdk.Duration.minutes(1440)
      },
      vpc,
      securityGroups: [vpcSg],
      vpcSubnets: {
        subnetType: ec2.SubnetType.ISOLATED
      },
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

    const handler = new lambda.DockerImageFunction(this, 'Handler', {
      code: lambda.DockerImageCode.fromImageAsset('../'),
      vpc,
      vpcSubnets: vpc.selectSubnets({ subnetType: ec2.SubnetType.PRIVATE }),
      timeout: cdk.Duration.seconds(30),
      memorySize: 256,
      environment: {
        DB_HOST: aurora.clusterEndpoint.hostname,
        DB_USER: aurora.secret?.secretValueFromJson('username').toString()!,
        DB_PASSWORD: aurora.secret?.secretValueFromJson('password').toString()!,
        RAILS_MASTER_KEY: process.env.RAILS_MASTER_KEY!,
        SECRET_KEY_BASE: process.env.SECRET_KEY_BASE!,
        TWITTER_API_KEY: process.env.TWITTER_API_KEY!,
        TWITTER_API_SECRET: process.env.TWITTER_API_SECRET!
      }
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
    //     PMA_HOSTS: aurora.clusterEndpoint.hostname,
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
