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
  description = "If true, the Terraform project context will be included in the name"
}

variable "name_infix_default" {
  type    = bool
  default = true
}

variable "name_prepend_default" {
  type        = string
  default     = ""
  description = "Prepended after key"
}

variable "std_map" {
  type = object({
    name_replace_regex   = string
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}

variable "vault_map" {
  type = map(object({
    changeable_for_days   = optional(number)
    force_destroy_enabled = optional(bool)
    kms_key_key           = optional(string)
    max_retention_days    = optional(number)
    min_retention_days    = optional(number)
    name_append           = optional(string)
    name_infix            = optional(bool)
    name_override         = optional(string)
    name_prepend          = optional(string)
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
  type    = number
  default = null
}
