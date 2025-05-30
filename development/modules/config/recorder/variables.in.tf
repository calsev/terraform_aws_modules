variable "kms_data_map" {
  type = map(object({
    key_arn = string
  }))
  default     = null
  description = "Must be provided if any recorder specifies a key."
}

{{ name.var() }}

variable "record_map" {
  type = map(object({
    exclusion_by_resource_type_list = optional(list(string))
    global_resource_types_included  = optional(bool)
    iam_role_arn                    = optional(string)
    is_enabled                      = optional(bool)
    kms_key_key                     = optional(string)
    mode_override_map = optional(map(object({
      record_frequency   = optional(string)
      resource_type_list = optional(list(string))
    })))
    mode_record_frequency          = optional(string)
    {{ name.var_item() }}
    resource_all_supported_enabled = optional(bool)
    resource_type_list             = optional(list(string))
    s3_bucket_key                  = optional(string)
    s3_object_key_prefix           = optional(string)
    snapshot_frequency             = optional(string)
    sns_topic_key                  = optional(string)
    strategy_use_only              = optional(string)
  }))
}

variable "record_exclusion_by_resource_type_list_default" {
  type        = list(string)
  default     = []
  description = "Ignored if resource_all_supported_enabled"
}

variable "record_global_resource_types_included_default" {
  type    = bool
  default = true
}

variable "record_iam_role_arn_default" {
  type        = string
  default     = null
  description = "This will usually and should be the service-linked role for Config."
}

variable "record_is_enabled_default" {
  type    = bool
  default = true
}

variable "record_kms_key_key_default" {
  type    = string
  default = null
}

variable "record_mode_override_map_default" {
  type = map(object({
    record_frequency   = optional(string)
    resource_type_list = optional(list(string))
  }))
  default = {
    iam_global_resources = {
      record_frequency   = null
      resource_type_list = null
    }
  }
}

variable "record_mode_override_record_frequency_default" {
  type    = string
  default = "DAILY"
  validation {
    condition     = contains(["CONTINUOUS", "DAILY"], var.record_mode_override_record_frequency_default)
    error_message = "Invalid record frequency"
  }
}

variable "record_mode_override_resource_type_list_default" {
  type    = list(string)
  default = ["AWS::IAM::Group", "AWS::IAM::Policy", "AWS::IAM::Role", "AWS::IAM::User"]
}

variable "record_mode_record_frequency_default" {
  type    = string
  default = "CONTINUOUS"
  validation {
    condition     = contains(["CONTINUOUS", "DAILY"], var.record_mode_record_frequency_default)
    error_message = "Invalid record frequency"
  }
}

variable "record_resource_all_supported_enabled_default" {
  type    = bool
  default = true
}

variable "record_resource_type_list_default" {
  type        = list(string)
  default     = []
  description = "Ignored if resource_all_supported_enabled"
}

variable "record_s3_bucket_key_default" {
  type    = string
  default = null
}

variable "record_s3_object_key_prefix_default" {
  type    = string
  default = null
}

variable "record_snapshot_frequency_default" {
  type    = string
  default = "TwentyFour_Hours"
  validation {
    condition     = contains(["One_Hour", "Three_Hours", "Six_Hours", "Twelve_Hours", "TwentyFour_Hours"], var.record_snapshot_frequency_default)
    error_message = "Invalid strategy"
  }
}

variable "record_sns_topic_key_default" {
  type    = string
  default = null
}

variable "record_strategy_use_only_default" {
  type    = string
  default = "ALL_SUPPORTED_RESOURCE_TYPES"
  validation {
    condition     = contains(["ALL_SUPPORTED_RESOURCE_TYPES", "EXCLUSION_BY_RESOURCE_TYPES", "INCLUSION_BY_RESOURCE_TYPES"], var.record_strategy_use_only_default)
    error_message = "Invalid strategy"
  }
}

variable "s3_data_map" {
  type = map(object({
    name_effective = string
  }))
}

variable "sns_data" {
  type = map(object({
    topic_map = map(object({
      topic_arn = string
    }))
  }))
  default     = null
  description = "Must be provided if any recorder specifies an sns key"
}

{{ std.map() }}
