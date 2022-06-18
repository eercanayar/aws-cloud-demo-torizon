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

aws s3 cp components/edgeManagerClientCameraIntegration/camera_integration_edgemanger_client.py s3://${COMPONENTS_BUCKET_NAME}/mlops-deployment/aws.sagemaker.edgeManagerClientCameraIntegration/0.2.0/

COMPONENT_RECIPE=edgeManagerClientCameraIntegration.yaml

aws greengrassv2 get-component --arn ${CAMERA_COMPONENT_ARN} --recipe-output-format YAML --query recipe --output text | base64 --decode > ${COMPONENT_RECIPE}

cp ${COMPONENT_RECIPE} deploy/
$(replace_in_file "s/ComponentVersion: \"0.1.0\"/ComponentVersion: \"0.2.0\"/g" deploy/${COMPONENT_RECIPE})
$(replace_in_file "s/ComponentDependencies:/ComponentDependencies:\n  com.mlops.xray:\n    VersionRequirement: \">=1.1.0\"\n    DependencyType: \"HARD\"/g" deploy/${COMPONENT_RECIPE})
$(replace_in_file "s/python3/pip install aws-xray-sdk \&\& python3/g" deploy/${COMPONENT_RECIPE})
$(replace_in_file "s/${COMPONENTS_BUCKET_NAME}\/artifacts\/aws.sagemaker.edgeManagerClientCameraIntegration\/0.1.0\/camera_integration_edgemanger_client.py/${COMPONENTS_BUCKET_NAME}\/mlops-deployment\/aws.sagemaker.edgeManagerClientCameraIntegration\/0.2.0\/camera_integration_edgemanger_client.py/g" deploy/${COMPONENT_RECIPE})

aws greengrassv2 create-component-version --inline-recipe fileb://deploy/${COMPONENT_RECIPE}

# clenaup
rm ${COMPONENT_RECIPE}