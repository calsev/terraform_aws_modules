variable "queue_map" {
  type = map(object({
    content_based_deduplication       = optional(bool)
    deduplication_scope               = optional(string)
    delay_seconds                     = optional(number)
    fifo_throughput_limit_type        = optional(string)
    iam_policy_json                   = optional(string)
    is_fifo                           = optional(bool)
    kms_data_key_reuse_period_minutes = optional(number)
    kms_master_key_id                 = optional(string)
    max_message_size_kib              = optional(number)
    message_retention_hours           = optional(number)
    receive_wait_time_seconds         = optional(number)
    redrive_allow_policy_json         = optional(number)
    redrive_policy_json               = optional(string)
    sqs_managed_sse_enabled           = optional(bool)
    visibility_timeout_seconds        = optional(number)
  }))
}

variable "queue_content_based_deduplication_default" {
  type        = bool
  default     = true
  description = "Ignored unless the queue is fifo"
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
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}
