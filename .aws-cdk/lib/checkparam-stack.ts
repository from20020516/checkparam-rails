import {
  Stack,
  StackProps,
  Duration,
  aws_ec2 as ec2,
  aws_events as events,
  aws_events_targets as eventsTargets,
  aws_lambda as lambda,
  aws_rds as rds,
  aws_s3 as s3,
  aws_s3_deployment as s3deployment,
  RemovalPolicy,
} from 'aws-cdk-lib'
import { Construct } from 'constructs'
import { HttpApi, HttpMethod } from '@aws-cdk/aws-apigatewayv2-alpha'
import { HttpUrlIntegration, HttpLambdaIntegration } from '@aws-cdk/aws-apigatewayv2-integrations-alpha'
import * as dotenv from 'dotenv'
import * as path from 'path'
dotenv.config({ path: path.join(__dirname, '../../.env') })

export class CheckparamStack extends Stack {
  constructor(scope: Construct, id: string, props?: StackProps) {
    super(scope, id, props)

    const vpc = new ec2.Vpc(this, 'Vpc', {
      maxAzs: 2,
      subnetConfiguration: [
        {
          cidrMask: 22,
          name: 'Public',
          subnetType: ec2.SubnetType.PUBLIC,
        },
        {
          cidrMask: 22,
          name: 'Isolated',
          subnetType: ec2.SubnetType.PRIVATE_ISOLATED,
        }
      ]
    })

    const mysql = new rds.ServerlessCluster(this, 'ServerlessCluster', {
      engine: rds.DatabaseClusterEngine.auroraMysql({
        version: rds.AuroraMysqlEngineVersion.VER_2_09_1,
      }),
      parameterGroup: new rds.ParameterGroup(this, 'ParameterGroup', {
        engine: rds.DatabaseClusterEngine.AURORA_MYSQL,
        parameters: {
          time_zone: 'Asia/Tokyo',
          character_set_client: 'utf8mb4',
          character_set_connection: 'utf8mb4',
          character_set_database: 'utf8mb4',
          character_set_filesystem: "utf8mb4",
          character_set_results: 'utf8mb4',
          character_set_server: 'utf8mb4',
          collation_server: 'utf8mb4_bin',
          collation_connection: 'utf8mb4_bin',
        },
      }),
      vpc,
      defaultDatabaseName: 'checkparam',
      enableDataApi: true,
      vpcSubnets: vpc.selectSubnets({ subnetType: ec2.SubnetType.PRIVATE_ISOLATED }),
      scaling: {
        minCapacity: rds.AuroraCapacityUnit.ACU_1,
        maxCapacity: rds.AuroraCapacityUnit.ACU_2,
        autoPause: Duration.minutes(15)
      },
      removalPolicy: RemovalPolicy.DESTROY,
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
      DB_ARN: mysql.clusterArn,
      DB_SECRET_ARN: mysql.secret!.secretArn,
      RAILS_MASTER_KEY: process.env.RAILS_MASTER_KEY!,
      SECRET_KEY_BASE: process.env.SECRET_KEY_BASE!,
      TWITTER_API_KEY: process.env.TWITTER_API_KEY!,
      TWITTER_API_SECRET: process.env.TWITTER_API_SECRET!
    }
    const handler = new lambda.DockerImageFunction(this, 'Handler', {
      code: lambda.DockerImageCode.fromImageAsset('../', {
        target: 'handler'
      }),
      timeout: Duration.seconds(30),
      retryAttempts: 0,
      memorySize: 256,
      environment,
      logRetention: 1,
    })
    mysql.grantDataApiAccess(handler)

    const updater = new lambda.DockerImageFunction(this, 'Updater', {
      code: lambda.DockerImageCode.fromImageAsset('../', {
        target: 'updater',
        entrypoint: ['/bin/sh', '-c'],
        cmd: ['bin/rails update:items']
      }),
      reservedConcurrentExecutions: 1,
      timeout: Duration.seconds(900),
      retryAttempts: 0,
      memorySize: 256,
      environment,
    })
    mysql.grantDataApiAccess(updater)

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

    const httpApi = new HttpApi(this, 'HttpAPI', {
      defaultIntegration: new HttpLambdaIntegration('DefaultHttpIntegration', handler)
    })
    httpApi.addRoutes({
      integration: new HttpUrlIntegration('favicon.ico', `${bucket.bucketWebsiteUrl}/favicon.ico`),
      path: '/favicon.ico',
      methods: [HttpMethod.GET]
    })
    httpApi.addRoutes({
      integration: new HttpUrlIntegration('apple-touch-icon.png', `${bucket.bucketWebsiteUrl}/apple-touch-icon.png`),
      path: '/apple-touch-icon.png',
      methods: [HttpMethod.GET]
    })
    httpApi.addRoutes({
      integration: new HttpUrlIntegration('assets', `${bucket.bucketWebsiteUrl}/assets/{proxy}`),
      path: '/assets/{proxy}',
      methods: [HttpMethod.GET]
    })
    httpApi.addRoutes({
      integration: new HttpUrlIntegration('icons', `https://static.ffxiah.com/images/icon/{proxy}`),
      path: '/icons/{proxy}',
      methods: [HttpMethod.GET]
    })
  }
}
