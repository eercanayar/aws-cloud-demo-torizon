
source ../project_settings.sh
source ../deploy/project_config.sh

export AWS_DEFAULT_OUTPUT="json"
export AWS_PAGER=""

aws iam attach-role-policy --policy-arn arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess --role-name ${ROLE_NAME}
