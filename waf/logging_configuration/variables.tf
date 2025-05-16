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
    name_append             = optional(string)
    name_include_app_fields = optional(bool)
    name_infix              = optional(bool)
    name_prefix             = optional(string)
    name_prepend            = optional(string)
    name_suffix             = optional(string)
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
  description = "Must be provided if any log config specifies a bucket"
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
