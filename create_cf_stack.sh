#!/usr/bin/env bash
COMMITTER_EMAIL="$(git log -2 $TRAVIS_COMMIT --pretty="%cE"|grep -v -m1 noreply@github.com)"
AUTHOR_NAME="$(git log -1 $TRAVIS_COMMIT --pretty="%aN")"

# EC2 instance for demo
STACK_NAME="ec2-demo2"
DEPARTMENT="Platform"
PROJECT="Infrastructure"
INSTANCE_TYPE="t2.nano"
CF_TEMPLATE="ec2.yml"
CLI_CMD="aws cloudformation create-stack \
--stack-name $STACK_NAME \
--capabilities CAPABILITY_NAMED_IAM \
--on-failure DELETE \
--notification-arns $CloudformationNotifyLambdaTopicArn \
--template-body file://cf_templates/$CF_TEMPLATE \
--parameters \
ParameterKey=VpcName,ParameterValue="computevpc" \
ParameterKey=VpcSubnet,ParameterValue="PrivateSubnet" \
ParameterKey=KeyName,ParameterValue="scicomp" \
ParameterKey=Department,ParameterValue=\"$DEPARTMENT\" \
ParameterKey=Project,ParameterValue=\"$PROJECT\" \
ParameterKey=OwnerEmail,ParameterValue=\"$COMMITTER_EMAIL\" \
ParameterKey=InstanceType,ParameterValue=\"$INSTANCE_TYPE\" \
ParameterKey=JcServiceApiKey,ParameterValue=\"$JcServiceApiKey\" \
ParameterKey=JcSystemsGroupId,ParameterValue=\"$JcSystemsGroupId\" \
ParameterKey=JcConnectKey,ParameterValue=\"$JcConnectKey\""
message=$($CLI_CMD 2>&1 1>/dev/null)
error_code=$(echo $?)
if [[ $error_code -ne 0 && $message =~ .*"AlreadyExistsException".* ]]; then
  error_code=0
elif [[ $error_code -ne 0 ]]; then
  echo $message
  exit $error_code
else
  echo -e "\nCreating stack $STACK_NAME with template cf_templates/$CF_TEMPLATE"
fi

# EC2 instance for demo
STACK_NAME="ec2-demo3"
DEPARTMENT="Platform"
PROJECT="Infrastructure"
INSTANCE_TYPE="t2.nano"
CF_TEMPLATE="ec2.yml"
CLI_CMD="aws cloudformation create-stack \
--stack-name $STACK_NAME \
--capabilities CAPABILITY_NAMED_IAM \
--on-failure DELETE \
--notification-arns $CloudformationNotifyLambdaTopicArn \
--template-body file://cf_templates/$CF_TEMPLATE \
--parameters \
ParameterKey=VpcName,ParameterValue="computevpc" \
ParameterKey=VpcSubnet,ParameterValue="PrivateSubnet" \
ParameterKey=KeyName,ParameterValue="scicomp" \
ParameterKey=Department,ParameterValue=\"$DEPARTMENT\" \
ParameterKey=Project,ParameterValue=\"$PROJECT\" \
ParameterKey=OwnerEmail,ParameterValue=\"$COMMITTER_EMAIL\" \
ParameterKey=InstanceType,ParameterValue=\"$INSTANCE_TYPE\" \
ParameterKey=JcServiceApiKey,ParameterValue=\"$JcServiceApiKey\" \
ParameterKey=JcSystemsGroupId,ParameterValue=\"$JcSystemsGroupId\" \
ParameterKey=JcConnectKey,ParameterValue=\"$JcConnectKey\""
message=$($CLI_CMD 2>&1 1>/dev/null)
error_code=$(echo $?)
if [[ $error_code -ne 0 && $message =~ .*"AlreadyExistsException".* ]]; then
  error_code=0
elif [[ $error_code -ne 0 ]]; then
  echo $message
  exit $error_code
else
  echo -e "\nCreating stack $STACK_NAME with template cf_templates/$CF_TEMPLATE"
fi
