variable "event_map" {
  type = map(object({
    cron_expression            = optional(string)
    dead_letter_queue_enabled  = optional(bool)
    definition_arn             = optional(string)
    event_bus_name             = optional(string)
    event_pattern_json         = optional(string)
    iam_role_arn_custom        = optional(string)
    iam_role_use_custom        = optional(bool)
    input                      = optional(string)
    input_path                 = optional(string)
    input_transformer_path_map = optional(map(string))
    input_transformer_template = optional(string)
    is_enabled                 = optional(bool)
    retry_attempts             = optional(number)
    target_arn                 = optional(string)
    target_service             = optional(string)
    task_count                 = optional(number)
  }))
}

variable "event_cron_expression_default" {
  type        = string
  default     = null
  description = "Either Cron expression or event pattern is required"
}

variable "event_dead_letter_queue_enabled_default" {
  type        = bool
  default     = true
  description = "Ignored if the target is a log group"
}

variable "event_definition_arn_default" {
  type        = string
  default     = null
  description = "An ECS task or Batch job definition"
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

variable "event_input_transformer_template_default" {
  type        = string
  default     = null
  description = "If an input path is provided, defaults to a simple dict of the inputs"
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
  description = "An ECS cluster, Batch job queue, Cloudwatch log group ..."
}

variable "event_target_service_default" {
  type        = string
  default     = null
  description = "This is required so that the set of resources does not depend on state, as it typically would with target and definition ARNs"
  validation {
    condition     = var.event_target_service_default == null ? true : contains(["batch", "ecs", "logs"], var.event_target_service_default)
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
}

variable "std_map" {
  type = object({
    access_title_map               = map(string)
    aws_account_id                 = string
    aws_region_name                = string
    iam_partition                  = string
    resource_name_prefix           = string
    resource_name_suffix           = string
    service_resource_access_action = map(map(map(list(string))))
    tags                           = map(string)
  })
}
