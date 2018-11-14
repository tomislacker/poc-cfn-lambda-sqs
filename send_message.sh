#!/bin/bash

set -eo pipefail

get_topic_arn ()
{
    aws cloudformation describe-stacks \
        --profile ${AWS_PROFILE} \
        --region ${REGION} \
        --stack-name ${STACK_NAME} \
        --query 'Stacks[0].Outputs[?OutputKey==`TopicArn`].OutputValue' \
        --output text
}

ARN=$(get_topic_arn)
echo "Sending message to ${ARN}"

aws sns publish \
    --profile ${AWS_PROFILE} \
    --region ${REGION} \
    --topic-arn ${ARN} \
    --subject "Message at $(date --iso-8601=seconds)" \
    --message $(date +%s)
