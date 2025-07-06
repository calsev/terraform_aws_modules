variable "alert_level_default" {
  type    = string
  default = "general_medium"
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
    "read_write",
  ]
}

variable "policy_create_default" {
  type    = bool
  default = true
}

variable "policy_name_append_default" {
  type    = string
  default = "dynamodb"
}

variable "policy_name_prefix_default" {
  type    = string
  default = ""
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

variable "table_map" {
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
    attribute_map                  = optional(map(string))
    billing_mode                   = optional(string)
    create_policy                  = optional(bool)
    deletion_protection_enabled    = optional(bool)
    gsi_hash_key                   = optional(string)
    gsi_name                       = optional(string)
    gsi_non_key_attribute_list     = optional(list(string))
    gsi_projection_type            = optional(string)
    gsi_range_key                  = optional(string)
    gsi_read_capacity              = optional(number)
    gsi_write_capacity             = optional(number)
    hash_key                       = optional(string)
    lsi_name                       = optional(string)
    lsi_non_key_attribute_list     = optional(list(string))
    lsi_projection_type            = optional(string)
    lsi_range_key                  = optional(string)
    name_append                    = optional(string)
    name_include_app_fields        = optional(bool)
    name_infix                     = optional(bool)
    name_prefix                    = optional(string)
    name_prepend                   = optional(string)
    name_suffix                    = optional(string)
    point_in_time_recovery_enabled = optional(bool)
    policy_access_list             = optional(list(string))
    policy_create                  = optional(bool)
    policy_name_append             = optional(string)
    range_key                      = optional(string)
    read_capacity                  = optional(number)
    server_side_encryption_enabled = optional(bool)
    stream_enabled                 = optional(bool)
    stream_view_type               = optional(string)
    ttl_attribute_name             = optional(string)
    write_capacity                 = optional(number)
  }))
}

variable "table_alarm_map_default" {
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
    read_iops = {
      alarm_action_enabled                = null
      alarm_description                   = "Alarm when read capcity usage is high for table %s"
      alarm_name                          = "Read Capacity for %s"
      alert_level                         = null
      metric_name                         = "ConsumedReadCapacityUnits"
      metric_namespace                    = "AWS/DynamoDB"
      statistic_comparison_operator       = "GreaterThanThreshold"
      statistic_evaluation_period_count   = 1
      statistic_evaluation_period_seconds = 300
      statistic_for_metric                = "Sum"
      statistic_threshold_percentile      = null
      statistic_threshold_value           = 80
    }
    write_iops = {
      alarm_action_enabled                = null
      alarm_description                   = "Alarm when write capcity usage is high for table %s"
      alarm_name                          = "Write Capacity for %s"
      alert_level                         = null
      metric_name                         = "ConsumedWriteCapacityUnits"
      metric_namespace                    = "AWS/DynamoDB"
      statistic_comparison_operator       = "GreaterThanThreshold"
      statistic_evaluation_period_count   = 1
      statistic_evaluation_period_seconds = 300
      statistic_for_metric                = "Sum"
      statistic_threshold_percentile      = null
      statistic_threshold_value           = 80
    }
  }
}

variable "table_attribute_map_default" {
  type        = map(string)
  default     = {}
  description = "map of name to type, must include hash keys and range keys. Types are 'S': string, 'N': number, 'B': binary."
}

variable "table_billing_mode_default" {
  type    = string
  default = "PAY_PER_REQUEST"
  validation {
    condition     = contains(["PAY_PER_REQUEST", "PROVISIONED"], var.table_billing_mode_default)
    error_message = "Invalid billing mode"
  }
}

variable "table_create_policy_default" {
  type    = bool
  default = true
}

variable "table_deletion_protection_enabled_default" {
  type    = bool
  default = true
}

variable "table_gsi_hash_key_default" {
  type    = string
  default = null
}

variable "table_gsi_name_default" {
  type    = string
  default = null
}

variable "table_gsi_non_key_attribute_list_default" {
  type    = list(string)
  default = null
}

variable "table_gsi_projection_type_default" {
  type    = string
  default = "KEYS_ONLY"
  validation {
    condition     = contains(["ALL", "INCLUDE", "KEYS_ONLY"], var.table_gsi_projection_type_default)
    error_message = "Invalid projection type"
  }
}

variable "table_gsi_range_key_default" {
  type    = string
  default = null
}

variable "table_gsi_read_capacity_default" {
  type    = number
  default = null
}

variable "table_gsi_write_capacity_default" {
  type    = number
  default = null
}

variable "table_hash_key_default" {
  type        = string
  default     = null
  description = "Must be LockID for a Terraform lock table"
}

variable "table_lsi_name_default" {
  type    = string
  default = null
}

variable "table_lsi_non_key_attribute_list_default" {
  type    = list(string)
  default = null
}

variable "table_lsi_projection_type_default" {
  type    = string
  default = "KEYS_ONLY"
  validation {
    condition     = contains(["ALL", "INCLUDE", "KEYS_ONLY"], var.table_lsi_projection_type_default)
    error_message = "Invalid projection type"
  }
}

variable "table_lsi_range_key_default" {
  type    = string
  default = null
}

variable "table_point_in_time_recovery_enabled_default" {
  type    = bool
  default = true
}

variable "table_range_key_default" {
  type    = string
  default = null
}

variable "table_read_capacity_default" {
  type    = number
  default = null
}

variable "table_server_side_encryption_enabled_default" {
  type    = bool
  default = true
}

variable "table_stream_enabled_default" {
  type    = bool
  default = false
}

variable "table_stream_view_type_default" {
  type    = string
  default = "KEYS_ONLY"
  validation {
    condition     = contains(["KEYS_ONLY", "NEW_IMAGE", "OLD_IMAGE", "NEW_AND_OLD_IMAGES"], var.table_stream_view_type_default)
    error_message = "Invalid stream view type"
  }
}

variable "table_ttl_attribute_name_default" {
  type    = string
  default = null
}

variable "table_write_capacity_default" {
  type    = number
  default = null
}
