variable "group_map" {
  type = map(object({
    byte_scanned_cutoff_per_query      = optional(number)
    encryption_option                  = optional(string)
    force_destroy_enabled              = optional(bool)
    iam_role_arn_execution             = optional(string)
    is_enabled                         = optional(bool)
    kms_key_key                        = optional(string)
    name_append                        = optional(string)
    name_infix                         = optional(bool)
    name_override                      = optional(string)
    name_prepend                       = optional(string)
    output_s3_bucket_location          = optional(string)
    publish_cloudwatch_metrics_enabled = optional(bool)
    requester_pays_enabled             = optional(bool)
    selected_engine_version            = optional(string)
    workgroup_configuration_enforced   = optional(bool)
  }))
}

variable "group_byte_scanned_cutoff_per_query_default" {
  type    = number
  default = null
  validation {
    condition     = var.group_byte_scanned_cutoff_per_query_default == null ? true : 10485760 <= var.group_byte_scanned_cutoff_per_query_default
    error_message = "Invalid byte scanned cutoff per query"
  }
}

variable "group_encryption_option_default" {
  type        = string
  default     = null
  description = "Defaults to SSE_KMS if kms key specified, SSE_S3 otehrwise"
  validation {
    condition     = var.group_encryption_option_default == null ? true : contains(["CSE_KMS", "SSE_KMS", "SSE_S3"], var.group_encryption_option_default)
    error_message = "Invalid encryption option"
  }
}

variable "group_force_destroy_enabled_default" {
  type    = bool
  default = false
}

variable "group_iam_role_arn_execution_default" {
  type    = string
  default = null
}

variable "group_is_enabled_default" {
  type    = bool
  default = true
}

variable "group_kms_key_key_default" {
  type    = string
  default = null
}

variable "group_output_s3_bucket_location_default" {
  type    = string
  default = null
}

variable "group_publish_cloudwatch_metrics_enabled_default" {
  type    = bool
  default = true
}

variable "group_requester_pays_enabled_default" {
  type    = bool
  default = true
}

variable "group_selected_engine_version_default" {
  type    = string
  default = "AUTO"
}

variable "group_workgroup_configuration_enforced_default" {
  type    = bool
  default = true
}

variable "kms_data_map" {
  type = map(object({
    key_arn = string
  }))
  default     = null
  description = "Must be provided if any group specifies a key."
}

variable "name_append_default" {
  type        = string
  default     = ""
  description = "Appended after key"
}

variable "name_include_app_fields_default" {
  type        = bool
  default     = true
  description = "If true, the Terraform project context will be included in the name"
}

variable "name_infix_default" {
  type    = bool
  default = true
}

variable "name_prepend_default" {
  type        = string
  default     = ""
  description = "Prepended before key"
}

variable "std_map" {
  type = object({
    name_replace_regex   = string
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}
