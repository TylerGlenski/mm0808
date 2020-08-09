#!/bin/bash -xe
source /home/ec2-user/.bash_profile
# check if directory exists and cd into it then stop
[ -d "/home/ec2-user/app/release" ] && \
cd /home/ec2-user/app/release && \
npm stop