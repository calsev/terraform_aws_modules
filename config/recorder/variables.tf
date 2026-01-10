variable "kms_data_map" {
  type = map(object({
    key_arn = string
  }))
  default     = null
  description = "Must be provided if any recorder specifies a key."
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

variable "record_map" {
  type = map(object({
    cost_query_db_key               = optional(string)
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
    name_append                    = optional(string)
    name_include_app_fields        = optional(bool)
    name_infix                     = optional(bool)
    name_prefix                    = optional(string)
    name_prepend                   = optional(string)
    name_suffix                    = optional(string)
    resource_all_supported_enabled = optional(bool)
    resource_type_list             = optional(list(string))
    s3_bucket_key                  = optional(string)
    s3_object_key_prefix           = optional(string)
    snapshot_frequency             = optional(string)
    sns_topic_key                  = optional(string)
    strategy_use_only              = optional(string)
  }))
}

variable "record_cost_query_db_key_default" {
  type        = string
  default     = "config"
  description = "In specified Athena DB queries will be created."
}

variable "record_exclusion_by_resource_type_list_default" {
  type = list(string)
  default = [
    "AWS::Backup::RecoveryPoint",
    "AWS::EC2::Instance",
    "AWS::EC2::NetworkInterface",
    "AWS::EC2::Volume",
    "AWS::SSM::ManagedInstanceInventory",
  ]
  description = "Ignored if resource_all_supported_enabled"
}

variable "record_global_resource_types_included_default" {
  type        = bool
  default     = false
  description = "Requires resource_all_supported_enabled"
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
  type = list(string)
  default = [
    "AWS::AutoScaling::AutoScalingGroup",
    "AWS::EC2::SecurityGroup",
    "AWS::EC2::Subnet",
    "AWS::EC2::VPC",
    "AWS::IAM::Policy",
    "AWS::IAM::Role",
  ]
  description = "Break-even for daily recording is 4 continuous instances per resource. The default is resources that tend to have many configuration instances per day due to relationship churn."
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
  default = false
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
  default = "EXCLUSION_BY_RESOURCE_TYPES"
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
