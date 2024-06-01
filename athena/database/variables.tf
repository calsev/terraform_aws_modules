variable "db_map" {
  type = map(object({
    bucket_name             = optional(string)
    encryption_option       = optional(string)
    force_destroy           = optional(bool)
    kms_key_id              = optional(string)
    name_append             = optional(string)
    name_include_app_fields = optional(bool)
    name_infix              = optional(bool)
    property_map            = optional(map(string))
  }))
}

variable "db_bucket_name_default" {
  type    = string
  default = null
}

variable "db_encryption_option_default" {
  type    = string
  default = "SSE_S3"
  validation {
    condition     = contains(["CSE_KMS", "SSE_KMS", "SSE_S3"], var.db_encryption_option_default)
    error_message = "Invalid encryption_option"
  }
}

variable "db_force_destroy_default" {
  type    = bool
  default = false
}

variable "db_kms_key_id_default" {
  type    = string
  default = null
}

variable "db_property_map_default" {
  type    = map(string)
  default = {}
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

variable "std_map" {
  type = object({
    aws_account_id       = string
    name_replace_regex   = string
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}
