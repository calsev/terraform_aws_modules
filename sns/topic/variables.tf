variable "policy_access_list_default" {
  type = list(string)
  default = [
    "write",
  ]
}

variable "policy_create_default" {
  type    = bool
  default = true
}

variable "policy_name_append_default" {
  type    = string
  default = "topic"
}

variable "policy_name_prefix_default" {
  type    = string
  default = ""
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
    policy_access_list                 = optional(list(string))
    policy_create                      = optional(bool)
    policy_name_append                 = optional(string)
    policy_name_prefix                 = optional(string)
    is_fifo                            = optional(bool)
    kms_key                            = optional(string)
    name_append                        = optional(string)
    name_include_app_fields            = optional(bool)
    name_infix                         = optional(bool)
    name_prefix                        = optional(string)
    name_prepend                       = optional(string)
    name_suffix                        = optional(string)
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
