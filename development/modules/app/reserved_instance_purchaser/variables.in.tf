variable "event_schedule_expression_default" {
  type        = string
  default     = "rate(10 minutes)"
  description = "Either Cron expression or event pattern is required"
}

variable "iam_data" {
  type = object({
    iam_policy_arn_batch_submit_job = string
    iam_policy_arn_ecs_start_task   = string
    iam_policy_arn_lambda_vpc       = string
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
    {{ name.var_item() }}
    offer_max_duration_days     = optional(number)
    offer_max_hourly_price      = optional(number)
    schedule_expression         = optional(string)
    vpc_az_key_list             = optional(list(string))
    vpc_ipv6_allowed            = optional(bool)
    vpc_key                     = optional(string)
    vpc_security_group_key_list = optional(list(string))
    vpc_segment_key             = optional(string)
  }))
}

{{ name.var(append="purchaser") }}

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

{{ std.map() }}

variable "vpc_az_key_list_default" {
  type    = list(string)
  default = ["a", "b"]
}

variable "vpc_data_map" {
  type = map(object({
    security_group_id_map = map(string)
    segment_map = map(object({
      route_public  = bool
      subnet_id_map = map(string)
    }))
    vpc_id = string
  }))
  default     = null
  description = "Must be provided if any function is configured in a VPC"
}

variable "vpc_key_default" {
  type    = string
  default = null
}

variable "vpc_security_group_key_list_default" {
  type    = list(string)
  default = ["world_all_out"]
}

variable "vpc_segment_key_default" {
  type    = string
  default = "internal"
}
