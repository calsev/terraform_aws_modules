variable "event_schedule_expression_default" {
  type        = string
  default     = "rate(1 hour)"
  description = "Either Cron expression or event pattern is required"
}

variable "function_timeout_seconds_default" {
  type        = number
  default     = 15
  description = "This can take time for many log groups"
}

variable "iam_data" {
  type = object({
    iam_policy_arn_batch_submit_job = string
    iam_policy_arn_ecs_start_task   = string
    iam_policy_arn_lambda_vpc       = string
  })
}

variable "retention_default_days" {
  type    = number
  default = 365
}

variable "retention_max_days" {
  type    = number
  default = 365
}

variable "retention_min_days" {
  type    = number
  default = 7
}

variable "name_append_default" {
  type        = string
  default     = ""
  description = "Appended after key"
}

variable "name_include_app_fields_default" {
  type        = bool
  default     = true
  description = "If true, standard project context will be prefixed to the name. Ignored if not name_infix."
}

variable "name_infix_default" {
  type        = bool
  default     = true
  description = "If true, standard project prefix and resource suffix will be added to the name"
}

variable "name_prefix_default" {
  type        = string
  default     = ""
  description = "Prepended before context prefix"
}

variable "name_prepend_default" {
  type        = string
  default     = ""
  description = "Prepended before key"
}

# tflint-ignore: terraform_unused_declarations
variable "name_regex_allow_list" {
  type        = list(string)
  default     = []
  description = "By default, all punctuation is replaced by -"
}

variable "name_suffix_default" {
  type        = string
  default     = ""
  description = "Appended after context suffix"
}

variable "std_map" {
  type = object({
    access_title_map               = map(string)
    aws_account_id                 = string
    aws_region_name                = string
    config_name                    = string
    env                            = string
    iam_partition                  = string
    name_replace_regex             = string
    resource_name_prefix           = string
    resource_name_suffix           = string
    service_resource_access_action = map(map(map(list(string))))
    tags                           = map(string)
  })
}

variable "vpc_az_key_list_default" {
  type = list(string)
  default = [
    "a",
    "b",
  ]
}

variable "vpc_data_map" {
  type = map(object({
    name_simple           = string
    security_group_id_map = map(string)
    segment_map = map(object({
      route_public  = bool
      subnet_id_map = map(string)
      subnet_map = map(object({
        availability_zone_name = string
      }))
    }))
    vpc_assign_ipv6_cidr = bool
    vpc_cidr_block       = string
    vpc_id               = string
    vpc_ipv6_cidr_block  = string
  }))
  default     = null
  description = "Must be provided if any function is configured in a VPC"
}

variable "vpc_key_default" {
  type    = string
  default = null
}

variable "vpc_security_group_key_list_default" {
  type = list(string)
  default = [
    "world_all_out",
  ]
}

variable "vpc_segment_key_default" {
  type    = string
  default = "internal"
}
