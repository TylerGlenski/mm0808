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

echo Vars created so far:
echo GH_ACCESS_TOKEN = $GH_ACCESS_TOKEN
echo GH_OWNER = $GH_OWNER
echo GH_REPO = $GH_REPO
echo GH_BRANCH = $GH_BRANCH
echo CODEPIPELINE_BUCKET = $CODEPIPELINE_BUCKET
echo AWS_ACCOUNT_ID = $AWS_ACCOUNT_ID
echo EC2_INSTANCE_TYPE = $EC2_INSTANCE_TYPE
echo CLI_PROFILE = $CLI_PROFILE
echo REGION = $REGION
echo STACK_NAME = $STACK_NAME