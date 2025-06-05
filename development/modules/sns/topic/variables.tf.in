{{ std.map() }}

variable "subscription_map" {
  type = map(object({
    confirmation_timeout_min = optional(number)
    endpoint                 = optional(string) # Defaults to k
    endpoint_auto_confirms   = optional(bool)
    k_topic_list             = optional(list(string))
    protocol                 = optional(string)
    raw_message_delivery     = optional(bool)
  }))
}

variable "subscription_confirmation_timeout_min_default" {
  type        = number
  default     = 1
  description = "Only applicable for HTTP"
}

variable "subscription_endpoint_auto_confirms_default" {
  type    = bool
  default = false
}

variable "subscription_k_topic_list_default" {
  type        = list(string)
  default     = null
  description = "Defaults to all topics"
}

variable "subscription_protocol_default" {
  type    = string
  default = "email"
  validation {
    condition     = contains(["application", "email", "email-json", "firehose", "http", "https", "lambda", "sms", "sqs"], var.subscription_protocol_default)
    error_message = "Invalid protocol"
  }
}

variable "subscription_raw_message_delivery_default" {
  type    = bool
  default = false
}

variable "topic_map" {
  type = map(object({
    allow_events                       = optional(bool)
    enable_content_based_deduplication = optional(bool)
    is_fifo                            = optional(bool)
    kms_key                            = optional(string)
    signature_version                  = optional(string)
  }))
}

variable "topic_allow_events_default" {
  type        = bool
  default     = true
  description = "This disables encryption, as event targets for SNS cannot have identity-based policies"
}

variable "topic_enable_content_based_deduplication_default" {
  type    = bool
  default = false
}

variable "topic_is_fifo_default" {
  type        = bool
  default     = false
  description = "Only valid for SQS protocol"
}

variable "topic_kms_key_default" {
  type        = string
  default     = "alias/aws/sns"
  description = "Enables encryption if not null. Ignored if events are enabled."
}

variable "topic_signature_version_default" {
  type    = string
  default = "2"
}
