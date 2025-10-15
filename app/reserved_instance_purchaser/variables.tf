variable "event_schedule_expression_default" {
  type        = string
  default     = "rate(5 minutes)"
  description = "Either Cron expression or event pattern is required"
}

variable "function_timeout_seconds_default" {
  type    = number
  default = 30
}

variable "iam_data" {
  type = object({
    iam_policy_arn_batch_submit_job = string
    iam_policy_arn_ecs_start_task   = string
    iam_policy_arn_lambda_vpc       = string
  })
}

variable "log_group_class_default" {
  type    = string
  default = "STANDARD"
  validation {
    condition     = contains(["INFREQUENT_ACCESS", "STANDARD"], var.log_group_class_default)
    error_message = "Invalid log group class"
  }
}

variable "log_kms_key_id_default" {
  type    = string
  default = null
}

variable "log_retention_days_default" {
  type    = number
  default = 7
  validation {
    condition     = contains([0, 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653], var.log_retention_days_default)
    error_message = "Log retention must be one of a set of allowed values"
  }
}

variable "monitor_data" {
  type = object({
    alert = object({
      topic_map = map(object({
        topic_arn = string
      }))
    })
  })
}

variable "purchaser_map" {
  type = map(object({
    dry_run                     = optional(bool)
    email_recipient             = optional(string)
    email_sender                = optional(string)
    instance_platform           = optional(string)
    instance_tenancy            = optional(string)
    instance_type               = optional(string)
    max_total_instances         = optional(number)
    name_append                 = optional(string)
    name_include_app_fields     = optional(bool)
    name_infix                  = optional(bool)
    name_prefix                 = optional(string)
    name_prepend                = optional(string)
    name_suffix                 = optional(string)
    offer_max_duration_days     = optional(number)
    offer_max_hourly_price      = optional(number)
    schedule_expression         = optional(string)
    vpc_ipv6_allowed            = optional(bool)
    vpc_az_key_list             = optional(list(string))
    vpc_key                     = optional(string)
    vpc_security_group_key_list = optional(list(string))
    vpc_segment_key             = optional(string)
  }))
}

variable "name_append_default" {
  type        = string
  default     = "purchaser"
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

variable "purchaser_dry_run_default" {
  type    = bool
  default = false
}

variable "purchaser_email_recipient_default" {
  type    = string
  default = null
}

variable "purchaser_email_sender_default" {
  type    = string
  default = null
}

variable "purchaser_instance_platform_default" {
  type    = string
  default = "Linux/UNIX"
}

variable "purchaser_instance_tenancy_default" {
  type    = string
  default = "default"
}

variable "purchaser_instance_type_default" {
  type        = string
  default     = null
  description = "Defaults to key"
}

variable "purchaser_max_total_instances_default" {
  type    = number
  default = null
}

variable "purchaser_offer_max_duration_days_default" {
  type    = number
  default = null
}

variable "purchaser_offer_max_hourly_price_default" {
  type    = number
  default = null
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
