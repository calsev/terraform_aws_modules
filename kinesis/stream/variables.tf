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

variable "stream_map" {
  type = map(object({
    aws_region_name           = optional(string)
    encryption_type           = optional(string)
    enforce_consumer_deletion = optional(bool)
    kms_key_id                = optional(string)
    name_append               = optional(string)
    name_include_app_fields   = optional(bool)
    name_infix                = optional(bool)
    name_prefix               = optional(string)
    name_prepend              = optional(string)
    name_suffix               = optional(string)
    retention_period_h        = optional(number)
    shard_count               = optional(number)
    shard_level_metric_list   = optional(list(string))
    stream_capacity_mode      = optional(string)
  }))
}

variable "stream_aws_region_name_default" {
  type        = string
  default     = null
  description = "Defaults to region for provider"
}

variable "stream_encryption_type_default" {
  type    = string
  default = "KMS"
  validation {
    condition     = contains(["KMS", "NONE"], var.stream_encryption_type_default)
    error_message = "Invalid encryption type"
  }
}

variable "stream_enforce_consumer_deletion_default" {
  type    = bool
  default = false
}

variable "stream_kms_key_id_default" {
  type    = string
  default = "alias/aws/kinesis"
}

variable "stream_retention_period_h_default" {
  type    = number
  default = 24
  validation {
    condition     = 24 <= var.stream_retention_period_h_default && var.stream_retention_period_h_default <= 8760
    error_message = "Invalid retention period"
  }
}

variable "stream_shard_count_default" {
  type        = number
  default     = null
  description = "Required if stream_capacity_mode is PROVISIONED"
}

variable "stream_shard_level_metric_list_default" {
  type = list(string)
  default = [
    "IncomingBytes",
    "IteratorAgeMilliseconds",
    "OutgoingBytes",
    "ReadProvisionedThroughputExceeded",
    "WriteProvisionedThroughputExceeded",
  ]
}

variable "stream_capacity_mode_default" {
  type    = string
  default = "ON_DEMAND"
  validation {
    condition     = contains(["ON_DEMAND", "PROVISIONED"], var.stream_capacity_mode_default)
    error_message = "Invalid stream mode"
  }
}
