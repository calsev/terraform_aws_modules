variable "pool_map" {
  type = map(object({
    log_map = optional(map(object({
      event_source        = optional(string)
      log_level           = optional(string)
      cloudwatch_log_key  = optional(string)
      firehose_stream_arn = optional(string)
      s3_bucket_key       = optional(string)
    })))
    name_append             = optional(string)
    name_include_app_fields = optional(bool)
    name_infix              = optional(bool)
    name_prefix             = optional(string)
    name_prepend            = optional(string)
    name_suffix             = optional(string)
    user_pool_id            = string
  }))
}

variable "pool_log_map_default" {
  type = map(object({
    event_source        = optional(string)
    log_level           = optional(string)
    cloudwatch_log_key  = optional(string)
    firehose_stream_arn = optional(string)
    s3_bucket_key       = optional(string)
  }))
  default = {
    auth = {
      event_source        = null
      log_level           = "INFO" # No ERROR level
      cloudwatch_log_key  = "auth"
      firehose_stream_arn = null
      s3_bucket_key       = null
    }
    notification = {
      event_source        = "userNotification"
      log_level           = null
      cloudwatch_log_key  = "notification"
      firehose_stream_arn = null
      s3_bucket_key       = null
    }
  }
}

variable "pool_log_event_source_default" {
  type    = string
  default = "userAuthEvents"
  validation {
    condition     = contains(["userAuthEvents", "userNotification"], var.pool_log_event_source_default)
    error_message = "Invalid log event source"
  }
}

variable "pool_log_level_default" {
  type    = string
  default = "ERROR"
  validation {
    condition     = contains(["ERROR", "INFO"], var.pool_log_level_default)
    error_message = "Invalid log level"
  }
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

variable "s3_data_map" {
  type = map(object({
    bucket_arn = string
  }))
  default     = null
  description = "Must be provided if any log specifies s3_bucket_key"
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
