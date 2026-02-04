#!/bin/bash

aws ec2 create-security-group \
  --group-name my-sg2 \
  --description "My TEST security group" \
  --output json \
  && aws ec2 authorize-security-group-ingress \
  --group-name my-sg2 \
  --ip-permissions file://ingress.json
