resource "aws_ebs_encryption_by_default" "ebs_encryption_by_default_enabled" {
  enabled = var.ebs_encryption_by_default_enabled
}

resource "aws_ecs_account_setting_default" "ecs_aws_vpc_trunking_enabled" {
  name  = "awsvpcTrunking"
  value = var.ecs_aws_vpc_trunking_enabled ? "enabled" : "disabled"
}

resource "aws_ecs_account_setting_default" "ecs_container_instance_arn_long_format_enabled" {
  name  = "containerInstanceLongArnFormat"
  value = var.ecs_container_instance_arn_long_format_enabled ? "enabled" : "disabled"
}

resource "aws_ecs_account_setting_default" "ecs_container_insights_enabled" {
  name  = "containerInsights"
  value = var.ecs_container_insights_enabled ? "enabled" : "disabled"
}

# resource "aws_ecs_account_setting_default" "ecs_dual_stack_ipv6_enabled" {
#   name     = "dualStackIPv6"
#   value    = var.ecs_dual_stack_ipv6_enabled ? "enabled" : "disabled"
# }

resource "aws_ecs_account_setting_default" "ecs_fargate_fips_mode_enabled" {
  for_each = var.std_map.iam_partition == "aws" ? {} : { this = {} }
  name     = "fargateFIPSMode"
  value    = var.ecs_fargate_fips_mode_enabled ? "enabled" : "disabled"
}

resource "aws_ecs_account_setting_default" "ecs_fargate_task_retirement_wait_period_days" {
  name  = "fargateTaskRetirementWaitPeriod"
  value = var.ecs_fargate_task_retirement_wait_period_days
}

resource "aws_ecs_account_setting_default" "ecs_service_arn_long_format_enabled" {
  name  = "serviceLongArnFormat"
  value = var.ecs_service_arn_long_format_enabled ? "enabled" : "disabled"
}

resource "aws_ecs_account_setting_default" "ecs_tag_resource_authorization_enabled" {
  name  = "tagResourceAuthorization"
  value = var.ecs_tag_resource_authorization_enabled ? "on" : "off"
}

resource "aws_ecs_account_setting_default" "ecs_task_arn_long_format_enabled" {
  name  = "taskLongArnFormat"
  value = var.ecs_task_arn_long_format_enabled ? "enabled" : "disabled"
}
