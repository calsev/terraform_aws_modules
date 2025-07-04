variable "alert_level_default" {
  type    = string
  default = "general_medium"
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

variable "policy_access_list_default" {
  type = list(string)
  default = [
    "read",
    "write",
  ]
}

variable "policy_create_default" {
  type    = bool
  default = true
}

variable "policy_name_append_default" {
  type    = string
  default = "queue"
}

variable "policy_name_prefix_default" {
  type    = string
  default = ""
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

variable "queue_map" {
  type = map(object({
    alarm_map = optional(map(object({
      alarm_action_enabled                = optional(bool)
      alarm_description                   = string # Human-friendly description
      alarm_name                          = string # Human-friendly name
      alert_level                         = optional(string)
      metric_name                         = optional(string)
      metric_namespace                    = optional(string)
      statistic_comparison_operator       = optional(string)
      statistic_evaluation_period_count   = optional(number)
      statistic_evaluation_period_seconds = optional(number)
      statistic_for_metric                = optional(string)
      statistic_threshold_percentile      = optional(number)
      statistic_threshold_value           = optional(number)
    })))
    content_based_deduplication       = optional(bool)
    create_queue                      = optional(bool)
    deduplication_scope               = optional(string)
    delay_seconds                     = optional(number)
    fifo_throughput_limit_type        = optional(string)
    iam_policy_json                   = optional(string)
    is_fifo                           = optional(bool)
    kms_data_key_reuse_period_minutes = optional(number)
    kms_master_key_id                 = optional(string)
    max_message_size_kib              = optional(number)
    message_retention_hours           = optional(number)
    name_append                       = optional(string)
    name_include_app_fields           = optional(bool)
    name_infix                        = optional(bool)
    name_prefix                       = optional(string)
    name_prepend                      = optional(string)
    name_suffix                       = optional(string)
    policy_access_list                = optional(list(string))
    policy_create                     = optional(bool)
    policy_name_append                = optional(string)
    policy_name_prefix                = optional(string)
    receive_wait_time_seconds         = optional(number)
    redrive_allow_policy_json         = optional(number)
    redrive_policy_json               = optional(string)
    sqs_managed_sse_enabled           = optional(bool)
    visibility_timeout_seconds        = optional(number)
  }))
}

variable "queue_alarm_map_default" {
  type = map(object({
    alarm_action_enabled                = optional(bool)
    alarm_description                   = string # Human-friendly description
    alarm_name                          = string # Human-friendly name
    alert_level                         = optional(string)
    metric_name                         = optional(string)
    metric_namespace                    = optional(string)
    statistic_comparison_operator       = optional(string)
    statistic_evaluation_period_count   = optional(number)
    statistic_evaluation_period_seconds = optional(number)
    statistic_for_metric                = optional(string)
    statistic_threshold_percentile      = optional(number)
    statistic_threshold_value           = optional(number)
  }))
  default = {
    message_age = {
      alarm_action_enabled                = null
      alarm_description                   = "Alarm when message age is high for queue %s"
      alarm_name                          = "Message Age for %s"
      alert_level                         = null
      metric_name                         = "ApproximateAgeOfOldestMessage"
      metric_namespace                    = "AWS/SQS"
      statistic_comparison_operator       = "GreaterThanThreshold"
      statistic_evaluation_period_count   = 1
      statistic_evaluation_period_seconds = 300
      statistic_for_metric                = "Maximum"
      statistic_threshold_percentile      = null
      statistic_threshold_value           = 60 * 60 # 1 hour in seconds
    }
  }
}

variable "queue_content_based_deduplication_default" {
  type        = bool
  default     = true
  description = "Ignored unless the queue is fifo"
}

variable "queue_create_queue_default" {
  type    = bool
  default = true
}

variable "queue_deduplication_scope_default" {
  type        = string
  default     = "queue"
  description = "Ignored unless the queue is fifo"
  validation {
    condition     = contains(["messageGroup", "queue"], var.queue_deduplication_scope_default)
    error_message = "Invalid deduplication scope"
  }
}

variable "queue_delay_seconds_default" {
  type    = number
  default = 0
}

variable "queue_fifo_throughput_limit_type_default" {
  type        = string
  default     = "perQueue"
  description = "Ignored unless the queue is fifo"
  validation {
    condition     = contains(["perMessageGroupId", "perQueue"], var.queue_fifo_throughput_limit_type_default)
    error_message = "Invalid throughput limit type"
  }
}

variable "queue_iam_policy_json_default" {
  type    = string
  default = null
}

variable "queue_is_fifo_default" {
  type    = bool
  default = true
}

variable "queue_kms_data_key_reuse_period_minutes_default" {
  type    = number
  default = 5
}

variable "queue_kms_master_key_id_default" {
  type    = string
  default = null
}

variable "queue_max_message_size_kib_default" {
  type    = number
  default = 256
}

variable "queue_message_retention_hours_default" {
  type    = number
  default = 7 * 24
}

variable "queue_receive_wait_time_seconds_default" {
  type    = number
  default = 0
}

variable "queue_redrive_allow_policy_json_default" {
  type    = string
  default = null
}

variable "queue_redrive_policy_json_default" {
  type    = string
  default = null
}

variable "queue_sqs_managed_sse_enabled_default" {
  type    = bool
  default = true
}

variable "queue_visibility_timeout_seconds_default" {
  type    = number
  default = 30
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
