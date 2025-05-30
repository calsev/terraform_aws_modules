locals {
  output_data = {
    ebs_encryption_by_default_enabled              = var.ebs_encryption_by_default_enabled
    ecs_aws_vpc_trunking_enabled                   = var.ecs_aws_vpc_trunking_enabled
    ecs_container_instance_arn_long_format_enabled = var.ecs_container_instance_arn_long_format_enabled
    ecs_container_insights_enabled                 = var.ecs_container_insights_enabled
    ecs_dual_stack_ipv6_enabled                    = var.ecs_dual_stack_ipv6_enabled
    ecs_fargate_fips_mode_enabled                  = var.ecs_fargate_fips_mode_enabled
    ecs_fargate_task_retirement_wait_period_days   = var.ecs_fargate_task_retirement_wait_period_days
    ecs_service_arn_long_format_enabled            = var.ecs_service_arn_long_format_enabled
    ecs_tag_resource_authorization_enabled         = var.ecs_tag_resource_authorization_enabled
    ecs_task_arn_long_format_enabled               = var.ecs_task_arn_long_format_enabled
  }
}
