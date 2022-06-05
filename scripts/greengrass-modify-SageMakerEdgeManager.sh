#!/bin/bash
source ../deploy/project_config.sh

LAST_DEPLOYMENT_ID=$(aws greengrassv2 list-deployments --target-arn ${THING_GROUP_ARN} | jq -r '.deployments[0].deploymentId')

DEPLOYMENT=$(aws greengrassv2 get-deployment --deployment-id $LAST_DEPLOYMENT_ID)
SAGEMAKER_COMPONENT_MERGE=$(jq -r '.["components"]["aws.greengrass.SageMakerEdgeManager"]["configurationUpdate"]["merge"]' <<< "$DEPLOYMENT") 
echo ${SAGEMAKER_COMPONENT_MERGE}