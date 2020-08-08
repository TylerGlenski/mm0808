#!/bin/bash

STACK_NAME=mm0808
REGION=us-east-1
CLI_PROFILE=mm0808

EC2_INSTANCE_TYPE=t2.micro

# Deploy the CloudFormation template
echo -e "\n\n=========== Deploying main.yml ==========="
aws cloudformation deploy \
  --region $REGION \
  --profile $CLI_PROFILE \
  --stack-name $STACK_NAME \
  --template-file main.yml \
  --no-fail-on-empty-changeset \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameter-overrides \
    EC2InstanceType=$EC2_INSTANCE_TYPE

# if the deploy succeeded, show DNS name of created instance
if [ $? -eq 0 ]; then
  aws cloudformation list-exports \
    --profile mm0808 \
    --query "Exports[?Name=='InstanceEndpoint'].Value"
fi
