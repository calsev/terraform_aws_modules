variable "compute_arn" {
  type        = string
  description = "An ECS cluster or Batch job queue"
}

variable "cron_expression" {
  type        = string
  default     = null
  description = "Either Cron expression or event pattern is required"
}

variable "definition_arn" {
  type        = string
  description = "An ECS task or Batch job definition"
}

variable "iam_role_arn_start_task" {
  type = string
}

variable "is_enabled" {
  type    = bool
  default = true
}

variable "name" {
  type = string
}

variable "event_bus_name" {
  type        = string
  default     = "default"
  description = "Not supported for schedule expression and will be ignored"
}

variable "event_pattern_json" {
  type        = string
  default     = null
  description = "Either Event pattern or cron expression is required"
}

variable "retry_attempts" {
  type = number
  default = 0
  description = "Number of retries for Batch jobs"
}

variable "sqs_queue_arn_dead_letter" {
  type    = string
  default = null
}

variable "task_count" {
  type = number
  default = 1
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
