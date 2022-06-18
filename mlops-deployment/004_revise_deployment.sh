#!/bin/bash

OS=`uname`
# $(replace_in_file pattern file)
function replace_in_file() {
    if [ "$OS" = 'Darwin' ]; then
        # for MacOS
        sed -i '' -e "$1" "$2"
    else
        # for Linux and Windows
        sed -i'' -e "$1" "$2"
    fi
}

source ../project_settings.sh
source ../deploy/project_config.sh

export AWS_DEFAULT_OUTPUT="json"
export AWS_PAGER=""


LAST_DEPLOYMENT_ID=$(aws greengrassv2 list-deployments --target-arn ${THING_GROUP_ARN} | jq -r '.deployments[0].deploymentId')
DEPLOYMENT=$(aws greengrassv2 get-deployment --deployment-id $LAST_DEPLOYMENT_ID)

DEPLOYMENT=$(jq 'del(.revisionId)' <<<${DEPLOYMENT})
DEPLOYMENT=$(jq 'del(.deploymentStatus)' <<<${DEPLOYMENT})
DEPLOYMENT=$(jq 'del(.deploymentId)' <<<${DEPLOYMENT})
DEPLOYMENT=$(jq 'del(.iotJobId)' <<<${DEPLOYMENT})
DEPLOYMENT=$(jq 'del(.iotJobArn)' <<<${DEPLOYMENT})
DEPLOYMENT=$(jq 'del(.creationTimestamp)' <<<${DEPLOYMENT})
DEPLOYMENT=$(jq 'del(.isLatestForTarget)' <<<${DEPLOYMENT})
DEPLOYMENT=$(jq 'del(.tags)' <<<${DEPLOYMENT})
DEPLOYMENT=$(jq 'del(.iotJobConfiguration)' <<<${DEPLOYMENT})
DEPLOYMENT=$(jq '.components["aws.sagemaker.ew15-emirayar-demo_edgeManagerClientCameraIntegration"]["componentVersion"] = "0.2.0"' <<<${DEPLOYMENT})

DEPLOYMENT=$(jq '.components["com.mlops.xray"] = {"componentVersion": "1.1.0", "configurationUpdate": {"merge": "{\"region\":\"'${AWS_REGION}'\"}"}}' <<<${DEPLOYMENT})

echo ${DEPLOYMENT} > deploy/revised_deployment.json

aws greengrassv2 create-deployment --cli-input-json file://deploy/revised_deployment.json