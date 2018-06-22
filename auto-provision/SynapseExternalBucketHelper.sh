#!/usr/bin/env bash
set -e

# Run after execution of SynapseExternalBucket.yaml template

# Upload owner.txt file to a Synapse external bucket
STACK_NAME=$1
SYNAPSE_BUCKET_NAME=$(aws cloudformation list-exports --query "Exports[?Name=='us-east-1-$STACK_NAME-SynapseExternalBucket'].Value" --output text)
SYNAPSE_USER_NAME=$(aws cloudformation list-exports --query "Exports[?Name=='us-east-1-$STACK_NAME-SynapseUserName'].Value" --output text)
echo "$SYNAPSE_USER_NAME" > owner.txt
aws s3 cp owner.txt s3://$SYNAPSE_BUCKET_NAME/

# Send email to the bucket owner
COMMITTER_EMAIL="$(git log -2 $TRAVIS_COMMIT --pretty="%cE"|grep -v -m1 noreply@github.com)"
aws ses send-email --to "$COMMITTER_EMAIL" --subject "Scicomp Automated Provisioning" \
--text "An S3 bucket has been provisioned on your behalf. The bucket name is $SYNAPSE_BUCKET_NAME" \
--from "aws.scicomp@sagebase.org"
