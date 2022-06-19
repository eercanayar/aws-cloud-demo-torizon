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

echo "> S3 bucket for components: $COMPONENTS_BUCKET_NAME"
mkdir deploy

wget https://s3.us-east-2.amazonaws.com/aws-xray-assets.us-east-2/xray-daemon/aws-xray-daemon-linux-arm64-3.x.zip
unzip -j aws-xray-daemon-linux-arm64-3.x.zip "xray"
rm aws-xray-daemon-linux-arm64-3.x.zip
mv xray components/com.mlops.xray/
cd components/com.mlops.xray/
zip -r ../../com.mlops.xray.zip *
cd ../..
aws s3 cp com.mlops.xray.zip s3://${COMPONENTS_BUCKET_NAME}/mlops-deployment/com.mlops.xray/1.1.0/

COMPONENT_RECIPE=com.mlops.xray.yaml
cp components/${COMPONENT_RECIPE} deploy/
$(replace_in_file "s/BUCKET_NAME/${COMPONENTS_BUCKET_NAME}/g" deploy/${COMPONENT_RECIPE})
$(replace_in_file "s/AWS_REGION/${AWS_REGION}/g" deploy/${COMPONENT_RECIPE})

aws greengrassv2 create-component-version --inline-recipe fileb://deploy/${COMPONENT_RECIPE}

# cleanup
rm com.mlops.xray.zip
rm components/com.mlops.xray/xray