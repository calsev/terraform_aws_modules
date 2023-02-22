variable "event_map" {
  type = map(object({
    cron_expression            = optional(string)
    definition_arn             = optional(string)
    event_bus_name             = optional(string)
    event_pattern_json         = optional(string)
    iam_role_arn_start_task    = optional(string)
    input                      = optional(string)
    input_path                 = optional(string)
    input_transformer_path_map = optional(map(string))
    input_transformer_template = optional(string)
    is_enabled                 = optional(bool)
    retry_attempts             = optional(number)
    sqs_queue_arn_dead_letter  = optional(string)
    target_arn                 = optional(string)
    task_count                 = optional(number)
  }))
}

variable "event_cron_expression_default" {
  type        = string
  default     = null
  description = "Either Cron expression or event pattern is required"
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

variable "event_iam_role_arn_start_task_default" {
  type    = string
  default = null
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

variable "event_sqs_queue_arn_dead_letter_default" {
  type    = string
  default = null
}

variable "event_target_arn_default" {
  type        = string
  default     = null
  description = "An ECS cluster, Batch job queue, Cloudwatch log group ..."
}

variable "event_task_count_default" {
  type        = number
  default     = 1
  description = "Number of Batch jobs or ECS tasks to launch"
}

variable "std_map" {
  type = object({
    iam_partition        = string
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}
