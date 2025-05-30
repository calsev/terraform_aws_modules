variable "log_map" {
  type = map(object({
    destination_arn                                = optional(string)
    destination_file_format                        = optional(string)
    destination_hive_compatible_partitions_enabled = optional(bool)
    destination_per_hour_partition_enabled         = optional(bool)
    destination_type                               = optional(string)
    iam_role_arn_cloudwatch_logs                   = optional(string)
    iam_role_arn_cross_account_delivery            = optional(string)
    log_format                                     = optional(string)
    max_aggregation_interval_seconds               = optional(number)
    name_append                                    = optional(string)
    name_include_app_fields                        = optional(bool)
    name_infix                                     = optional(bool)
    name_prefix                                    = optional(string)
    name_prepend                                   = optional(string)
    name_suffix                                    = optional(string)
    source_id                                      = string
    source_type                                    = optional(string)
    traffic_type                                   = optional(string)
  }))
}

variable "log_destination_arn_default" {
  type    = string
  default = null
}

variable "log_destination_file_format_default" {
  type    = string
  default = "parquet"
  validation {
    condition     = contains(["parquet", "plain-text"], var.log_destination_file_format_default)
    error_message = "Invalid destination file format"
  }
}

variable "log_destination_hive_compatible_partitions_enabled_default" {
  type    = bool
  default = false
}

variable "log_destination_per_hour_partition_enabled_default" {
  type        = bool
  default     = false
  description = "Can reduce cost for queries at the expense of many partitions (default is daily partitions)"
}

variable "log_destination_type_default" {
  type    = string
  default = "s3"
  validation {
    condition     = contains(["cloud-watch-logs", "kinesis-data-firehose", "s3"], var.log_destination_type_default)
    error_message = "Invalid destination type"
  }
}

variable "log_format_default" {
  type    = string
  default = "$${srcaddr} $${dstaddr} $${srcport} $${dstport}"
}

variable "log_iam_role_arn_cloudwatch_logs_default" {
  type        = string
  default     = null
  description = "Required only if destination_type is cloud-watch-logs"
}

variable "log_iam_role_arn_cross_account_delivery_default" {
  type    = string
  default = null
}

variable "log_max_aggregation_interval_seconds_default" {
  type        = number
  default     = 600
  description = "Ignored when source_type is transit gateway or attachment"
  validation {
    condition     = contains([60, 600], var.log_max_aggregation_interval_seconds_default)
    error_message = "Invalid max aggregation interval seconds"
  }
}

variable "log_source_type_default" {
  type    = string
  default = "vpc"
  validation {
    condition     = contains(["eni", "subnet", "transit-gateway", "transit-gateway-attachment", "vpc"], var.log_source_type_default)
    error_message = "Invalid source type"
  }
}

variable "log_traffic_type_default" {
  type    = string
  default = "REJECT"
  validation {
    condition     = contains(["ACCEPT", "ALL", "REJECT"], var.log_traffic_type_default)
    error_message = "Invalid traffic type"
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
