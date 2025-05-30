variable "firehose_data_map" {
  type = map(object({
    firehose_arn = string
  }))
  default     = null
  description = "Must be provided if any log config specifies a firehose"
}

variable "log_data_map" {
  type = map(object({
    log_group_arn = string
  }))
  default     = null
  description = "Must be provided if any log config specifies a log group"
}

variable "log_map" {
  type = map(object({
    log_destination_log_group_key_list = optional(list(string))
    log_destination_firehose_key_list  = optional(list(string))
    log_destination_s3_bucket_key_list = optional(list(string))
    log_filter_map = optional(map(object({
      default_behavior = optional(string)
      filter_map = optional(map(object({
        behavior = optional(string)
        condition_map = optional(map(object({
          action     = optional(string)
          label_name = optional(string)
        })))
        requirement = optional(string)
      })))
    })))
    log_redacted_field_map = optional(map(object({
      value = string
    })))
    {{ name.var_item() }}
    waf_acl_arn             = optional(string)
  }))
}

variable "log_destination_log_group_key_list_default" {
  type    = list(string)
  default = []
}

variable "log_destination_firehose_key_list_default" {
  type    = list(string)
  default = []
}

variable "log_destination_s3_bucket_key_list_default" {
  type    = list(string)
  default = []
}

variable "log_filter_map_default" {
  type = map(object({
    default_behavior = optional(string)
    filter_map = optional(map(object({
      behavior = optional(string)
      condition_map = optional(map(object({
        action     = optional(string)
        label_name = optional(string)
      })))
      requirement = optional(string)
    })))
  }))
  default = {}
}

variable "log_filter_default_behavior_default" {
  type    = string
  default = "DROP"
  validation {
    condition     = contains(["DROP", "KEEP"], var.log_filter_default_behavior_default)
    error_message = "Invalid redacted field map"
  }
}

variable "log_filter_filter_map_default" {
  type = map(object({
    behavior = optional(string)
    condition_map = optional(map(object({
      action     = optional(string)
      label_name = optional(string)
    })))
    requirement = optional(string)
  }))
  default = {}
}

variable "log_filter_filter_behavior_default" {
  type    = string
  default = "DROP"
  validation {
    condition     = contains(["DROP", "KEEP"], var.log_filter_filter_behavior_default)
    error_message = "Invalid filter behavior"
  }
}

variable "log_filter_filter_condition_map_default" {
  type = map(object({
    action     = optional(string)
    label_name = optional(string)
  }))
  default = {}
}

variable "log_filter_filter_condition_action_default" {
  type    = string
  default = "COUNT"
  validation {
    condition     = contains(["ALLOW", "BLOCK", "COUNT"], var.log_filter_filter_condition_action_default)
    error_message = "Invalid filter action"
  }
}

variable "log_filter_filter_condition_label_name_default" {
  type    = string
  default = null
}

variable "log_filter_filter_requirement_default" {
  type    = string
  default = "MEETS_ALL"
  validation {
    condition     = contains(["MEETS_ALL", "MEETS_ANY"], var.log_filter_filter_requirement_default)
    error_message = "Invalid filter requirement"
  }
}

variable "log_redacted_field_map_default" {
  type = map(object({
    value = string
  }))
  default = {
    token = {
      value = "Authorization"
    }
  }
  description = "If value is in {method, query_string, uri_path}, that component will be redacted. Any other value will be interpreted as a header name to redact."
}

variable "log_waf_acl_arn_default" {
  type    = string
  default = null
}

{{ name.var() }}

variable "s3_data_map" {
  type = map(object({
    bucket_arn = string
  }))
  default     = null
  description = "Must be provided if any log config specifies a bucket"
}

{{ std.map() }}
