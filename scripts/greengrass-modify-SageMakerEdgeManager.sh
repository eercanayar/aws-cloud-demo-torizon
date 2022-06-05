#!/bin/bash
source ../deploy/project_config.sh

LAST_DEPLOYMENT_ID=$(aws greengrassv2 list-deployments --target-arn ${THING_GROUP_ARN} | jq '.deployments' | jq '.[0].deploymentId')

DEPLOYMENT=$(aws greengrassv2 get-deployment --deployment-id ${LAST_DEPLOYMENT_ID})

echo ${DEPLOYMENT}