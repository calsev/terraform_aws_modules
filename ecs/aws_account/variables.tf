variable "ebs_encryption_by_default_enabled" {
  type    = bool
  default = true
}

variable "ecs_aws_vpc_trunking_enabled" {
  type    = bool
  default = true
}

variable "ecs_container_instance_arn_long_format_enabled" {
  type    = bool
  default = true
}

variable "ecs_container_insights_enabled" {
  type    = bool
  default = true
}

variable "ecs_dual_stack_ipv6_enabled" {
  type        = bool
  default     = true
  description = "Not yet supported by AWS provider. Will be enabled after support is added."
}

variable "ecs_fargate_fips_mode_enabled" {
  type        = bool
  default     = true
  description = "Ignored if iam_partition is aws"
}

variable "ecs_fargate_task_retirement_wait_period_days" {
  type    = number
  default = 0
  validation {
    condition     = contains([0, 7, 14], var.ecs_fargate_task_retirement_wait_period_days)
    error_message = "Invalid retirement wait period"
  }
}

variable "ecs_service_arn_long_format_enabled" {
  type    = bool
  default = true
}

variable "ecs_tag_resource_authorization_enabled" {
  type    = bool
  default = true
}

variable "ecs_task_arn_long_format_enabled" {
  type    = bool
  default = true
}

variable "std_map" {
  type = object({
    iam_partition = string
  })
}
