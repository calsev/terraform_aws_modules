#!/bin/bash
# This file is managed with Terraform!

echo "creating deployment ..."

wait=''

while getopts 'w' flag; do
  case "$${flag}" in
    w) wait='true' ;;
  esac
done

ID=$(aws deploy create-deployment \
    --application-name ${codedeploy_application_name} \
    --deployment-group-name ${deployment_group_name} \
    --revision '{"revisionType": "AppSpecContent", "appSpecContent": {"content": "${app_spec_content}", "sha256": "${app_spec_sha256}"}}' \
    --output text \
    --query '[deploymentId]')

if [ ! -z "$wait" ]; then
    echo "waiting for deployment $deploymentId to finish ..."
    STATUS=$(aws deploy get-deployment \
        --deployment-id $ID \
        --output text \
        --query '[deploymentInfo.status]')

    while [[ $STATUS == "Created" || $STATUS == "InProgress" || $STATUS == "Pending" || $STATUS == "Queued" || $STATUS == "Ready" ]]; do
        echo "Status: $STATUS..."
        STATUS=$(aws deploy get-deployment \
            --deployment-id $ID \
            --output text \
            --query '[deploymentInfo.status]')

        SLEEP_TIME=30

        echo "Sleeping for: $SLEEP_TIME Seconds"
        sleep $SLEEP_TIME
    done

    if [[ $STATUS == "Succeeded" ]]; then
        echo "Deployment succeeded."
    else
        echo "Deployment failed!"
        exit 1
    fi
fi
