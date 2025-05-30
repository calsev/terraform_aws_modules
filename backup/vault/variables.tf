variable "kms_data_map" {
  type = map(object({
    key_arn = string
  }))
  default     = null
  description = "Must be provided if any vault specifies a key."
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

variable "vault_map" {
  type = map(object({
    changeable_for_days     = optional(number)
    force_destroy_enabled   = optional(bool)
    kms_key_key             = optional(string)
    max_retention_days      = optional(number)
    min_retention_days      = optional(number)
    name_append             = optional(string)
    name_include_app_fields = optional(bool)
    name_infix              = optional(bool)
    name_prefix             = optional(string)
    name_prepend            = optional(string)
    name_suffix             = optional(string)
  }))
}

variable "vault_changeable_for_days_default" {
  type        = number
  default     = null
  description = "If specified, creates a vault in compliance mode, otherwise governance mode"
}

variable "vault_force_destroy_enabled_default" {
  type    = bool
  default = false
}

variable "vault_kms_key_key_default" {
  type    = string
  default = null
}

variable "vault_max_retention_days_default" {
  type    = number
  default = null
}

variable "vault_min_retention_days_default" {
  type        = number
  default     = null
  description = "Applies to continuous backups as well"
}
