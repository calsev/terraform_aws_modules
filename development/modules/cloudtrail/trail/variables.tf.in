variable "kms_data_map" {
  type = map(object({
    policy_map = map(object({
      iam_policy_arn = string
    }))
    key_arn = string
  }))
  default     = null
  description = "Must be provided if any trail specifies a key."
}

variable "log_retention_days_default" {
  type    = number
  default = 14
  validation {
    condition     = contains([0, 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653], var.log_retention_days_default)
    error_message = "Log retention must be one of a set of allowed values"
  }
}

{{ name.var() }}

variable "s3_data_map" {
  type = map(object({
    name_effective = string
  }))
}

{{ std.map() }}

variable "trail_map" {
  type = map(object({
    advanced_event_selector_map = optional(map(map(object({
      ends_with_list      = optional(list(string))
      equal_list          = optional(list(string))
      field               = string
      not_ends_with_list  = optional(list(string))
      not_equal_list      = optional(list(string))
      not_start_with_list = optional(list(string))
      start_with_list     = optional(list(string))
    }))))
    event_selector_map = optional(map(object({
      data_resource_type                   = optional(string)
      data_resource_value_list             = optional(list(string))
      exclude_management_event_source_list = optional(list(string))
      include_management_events            = optional(bool)
      read_write_type                      = optional(string)
    })))
    include_global_service_events = optional(bool)
    insight_type_list             = optional(list(string))
    kms_key_key                   = optional(string)
    log_bucket_key                = optional(string)
    log_bucket_object_prefix      = optional(string)
    log_file_validation_enabled   = optional(bool)
    logging_enabled               = optional(bool)
    log_retention_days            = optional(number)
    multi_region_trail_enabled    = optional(bool)
    {{ name.var_item() }}
    organization_trail_enabled    = optional(bool)
    sns_topic_name                = optional(string)
  }))
}

variable "trail_advanced_event_selector_map_default" {
  type = map(map(object({
    ends_with_list      = optional(list(string), [])
    equal_list          = optional(list(string), [])
    field               = string
    not_ends_with_list  = optional(list(string), [])
    not_equal_list      = optional(list(string), [])
    not_start_with_list = optional(list(string), [])
    start_with_list     = optional(list(string), [])
  })))
  default     = {}
  description = "Conflicts with event_selector_map"
}

variable "trail_event_selector_map_default" {
  type = map(object({
    data_resource_type                   = optional(string)
    data_resource_value_list             = optional(list(string))
    exclude_management_event_source_list = optional(list(string))
    include_management_events            = optional(bool)
    read_write_type                      = optional(string)
  }))
  default     = {}
  description = "Conflicts with advanced_event_selector_map"
}

variable "trail_event_selector_data_resource_type_default" {
  type    = string
  default = null
}

variable "trail_event_selector_data_resource_value_list_default" {
  type    = string
  default = null
}

variable "trail_event_selector_exclude_management_event_source_list_default" {
  type    = string
  default = null
}

variable "trail_event_selector_include_management_events_default" {
  type    = bool
  default = true
}

variable "trail_event_selector_read_write_type_default" {
  type    = string
  default = "All"
  validation {
    condition     = contains(["All", "ReadOnly", "WriteOnly"], var.trail_event_selector_read_write_type_default)
    error_message = "Invalid read-write type"
  }
}

variable "trail_include_global_service_events_default" {
  type    = bool
  default = true
}

variable "trail_insight_type_list_default" {
  type        = list(string)
  default     = ["ApiCallRateInsight", "ApiErrorRateInsight"]
  description = "Only supported for management events"
  validation {
    condition     = length(setsubtract(toset(var.trail_insight_type_list_default), toset(["ApiCallRateInsight", "ApiErrorRateInsight"]))) == 0
    error_message = "Invalid insight type list"
  }
}

variable "trail_kms_key_key_default" {
  type    = string
  default = null
}

variable "trail_log_bucket_key_default" {
  type    = string
  default = null
}

variable "trail_log_bucket_object_prefix_default" {
  type    = string
  default = null
}

variable "trail_log_file_validation_enabled_default" {
  type    = bool
  default = true
}

variable "trail_logging_enabled_default" {
  type    = bool
  default = true
}

variable "trail_multi_region_trail_enabled_default" {
  type        = bool
  default     = true
  description = "If an account does not have at least one multi-region trail enabled it is a medium-severity security finding."
}

variable "trail_organization_trail_enabled_default" {
  type    = bool
  default = false
}

variable "trail_sns_topic_name_default" {
  type    = string
  default = null
}
