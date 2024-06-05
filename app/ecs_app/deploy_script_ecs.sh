#!/bin/bash
# This file is managed with Terraform!

aws ecs update-service --cluster ${ecs_cluster_name} --service ${ecs_service_name} --force-new-deployment
