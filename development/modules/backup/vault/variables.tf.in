variable "kms_data_map" {
  type = map(object({
    key_arn = string
  }))
  default     = null
  description = "Must be provided if any vault specifies a key."
}

{{ name.var() }}

{{ std.map() }}

variable "vault_map" {
  type = map(object({
    changeable_for_days   = optional(number)
    force_destroy_enabled = optional(bool)
    kms_key_key           = optional(string)
    max_retention_days    = optional(number)
    min_retention_days    = optional(number)
    {{ name.var_item() }}
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
