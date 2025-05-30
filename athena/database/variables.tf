variable "db_map" {
  type = map(object({
    bucket_name             = optional(string)
    encryption_option       = optional(string)
    force_destroy           = optional(bool)
    kms_key_id              = optional(string)
    name_append             = optional(string)
    name_include_app_fields = optional(bool)
    name_infix              = optional(bool)
    name_prefix             = optional(string)
    name_prepend            = optional(string)
    name_suffix             = optional(string)
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
