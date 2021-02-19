#!/usr/bin/env node
import 'source-map-support/register'
import * as cdk from '@aws-cdk/core'
import { CheckparamStack } from '../lib/checkparam-stack'

const app = new cdk.App()
new CheckparamStack(app, 'CheckparamStack', {
    env: {
        account: '492022549341',
        region: 'ap-northeast-1'
    }
})
