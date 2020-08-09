#!/bin/bash

STACK_NAME=mm0808
REGION=us-east-1
CLI_PROFILE=mm0808

EC2_INSTANCE_TYPE=t2.micro

AWS_ACCOUNT_ID=`aws sts get-caller-identity --profile mm0808 \
        --query "Account" --output text`
CODEPIPELINE_BUCKET="$STACK_NAME-$REGION-codepipeline-$AWS_ACCOUNT_ID"

# create access token for git
# set git variables
GH_ACCESS_TOKEN=$(cat ~/.github/mm0808-access-token)
GH_OWNER=$(cat ~/.github/mm0808-owner)
GH_REPO=$(cat ~/.github/mm0808-repo)
GH_BRANCH=main

# Deploy static resources
echo -e "\n\n========== Deploying setup.yml static  resources =========="
aws cloudformation deploy \
  --region $REGION \
  --profile $CLI_PROFILE \
  --stack-name $STACK_NAME \
  --template-file setup.yml \
  --no-fail-on-empty-changeset \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameter-overrides \
    CodePipelineBucket=$CODEPIPELINE_BUCKET

# Deploy the CloudFormation template
echo -e "\n\n========== Deploying main.yml =========="
aws cloudformation deploy \
  --region $REGION \
  --profile $CLI_PROFILE \
  --stack-name $STACK_NAME \
  --template-file main.yml \
  --no-fail-on-empty-changeset \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameter-overrides \
    EC2InstanceType=$EC2_INSTANCE_TYPE \
    GitOwner=$GH_OWNER \
    GitRepo=$GH_REPO \
    GitBranch=$GH_BRANCH \
    GitAccessToken=$GH_ACCESS_TOKEN \
    CodePipelineBucket=$CODEPIPELINE_BUCKET


# if the deploy succeeded, show DNS name of created instance
if [ $? -eq 0 ]; then
  aws cloudformation list-exports \
    --profile mm0808 \
    --query "Exports[?starts_with(Name, 'InstanceEndpoint')].Value"
fi
