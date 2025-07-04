variable "event_map" {
  type = map(object({
    dead_letter_queue_enabled         = optional(bool)
    definition_arn                    = optional(string)
    event_bus_name                    = optional(string)
    event_pattern_json                = optional(string)
    iam_role_arn_custom               = optional(string)
    iam_role_use_custom               = optional(bool)
    input                             = optional(string)
    input_path                        = optional(string)
    input_transformer_path_map        = optional(map(string))
    input_transformer_template_json   = optional(string)
    input_transformer_template_string = optional(string)
    is_enabled                        = optional(bool)
    name_append                       = optional(string)
    name_include_app_fields           = optional(bool)
    name_infix                        = optional(bool)
    name_prefix                       = optional(string)
    name_prepend                      = optional(string)
    name_suffix                       = optional(string)
    retry_attempts                    = optional(number)
    role_policy_attach_arn_map        = optional(map(string))
    role_policy_create_json_map       = optional(map(string))
    role_policy_inline_json_map       = optional(map(string))
    role_policy_managed_name_map      = optional(map(string))
    role_path                         = optional(string)
    schedule_expression               = optional(string)
    target_arn                        = optional(string)
    target_service                    = optional(string)
    task_count                        = optional(number)
    vpc_az_key_list                   = optional(list(string))
    vpc_key                           = optional(string)
    vpc_security_group_key_list       = optional(list(string))
    vpc_segment_key                   = optional(string)
  }))
}

variable "event_schedule_expression_default" {
  type        = string
  default     = null
  description = "Either Cron expression or event pattern is required"
}

variable "event_dead_letter_queue_enabled_default" {
  type        = bool
  default     = true
  description = "Ignored if the target is a log group or sns topic"
}

variable "event_definition_arn_default" {
  type        = string
  default     = null
  description = "An ECS task or Batch job definition, if relevant"
}

variable "event_bus_name_default" {
  type        = string
  default     = "default"
  description = "Not supported for schedule expression and will be ignored"
}

variable "event_pattern_json_default" {
  type        = string
  default     = null
  description = "Either Event pattern or cron expression is required"
}

variable "event_iam_role_arn_custom_default" {
  type        = string
  default     = null
  description = "By default, a policy is created that allows running the target and sending messages to the dead letter queue. Account for these actions when using a custom policy. Ignored if the target is a log group."
}

variable "event_iam_role_use_custom_default" {
  type        = bool
  default     = false
  description = "This is required so that the set of resources does not depend on state, as it typically would with role ARNs"
}

variable "event_input_default" {
  type    = string
  default = null
}

variable "event_input_path_default" {
  type    = string
  default = null
}

variable "event_input_transformer_path_map_default" {
  type    = map(string)
  default = null
}

variable "event_input_transformer_template_json_default" {
  type        = string
  default     = null
  description = "If an input path is provided, defaults to a simple map of the inputs. Not used if a template string is provided"
}

variable "event_input_transformer_template_string_default" {
  type        = string
  default     = null
  description = "If provided, will be used as a template string"
}

variable "event_is_enabled_default" {
  type    = bool
  default = true
}

variable "event_retry_attempts_default" {
  type        = number
  default     = 0
  description = "Number of retries for Batch jobs"
}

variable "event_target_arn_default" {
  type        = string
  default     = null
  description = "An ECS cluster, Batch job queue, Cloudwatch log group, SNS topic ..."
}

variable "event_target_service_default" {
  type        = string
  default     = null
  description = "This is required so that the set of resources does not depend on state, as it typically would with target and definition ARNs"
  validation {
    condition     = var.event_target_service_default == null ? true : contains(["batch", "ecs", "events", "lambda", "logs", "sns"], var.event_target_service_default)
    error_message = "Invalid target service"
  }
}

variable "event_task_count_default" {
  type        = number
  default     = 1
  description = "Number of Batch jobs or ECS tasks to launch"
}

variable "iam_data" {
  type = object({
    iam_policy_arn_batch_submit_job = string
    iam_policy_arn_ecs_start_task   = string
  })
  default     = null
  description = "Must be provided for Batch and ECS targets"
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

variable "name_append_default" {
  type        = string
  default     = "trigger"
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

variable "role_policy_attach_arn_map_default" {
  type    = map(string)
  default = {}
}

variable "role_policy_create_json_map_default" {
  type    = map(string)
  default = {}
}

variable "role_policy_inline_json_map_default" {
  type    = map(string)
  default = {}
}

variable "role_policy_managed_name_map_default" {
  type        = map(string)
  default     = {}
  description = "The short identifier of the managed policy, the part after 'arn:<iam_partition>:iam::aws:policy/'"
}

variable "role_path_default" {
  type    = string
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
  description = "Required for ECS targets"
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
