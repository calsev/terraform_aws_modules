variable "secret_map" {
  type = map(object({
    force_overwrite      = optional(bool)
    kms_key_id           = optional(string)
    policy_json          = optional(string)
    recovery_window_days = optional(string)
  }))
}

variable "secret_force_overwrite_default" {
  type    = bool
  default = false
}

variable "secret_kms_key_id_default" {
  type    = string
  default = null
}

variable "secret_policy_json_default" {
  type    = string
  default = "{}"
}

variable "secret_recovery_window_days_default" {
  type        = number
  default     = 30
  description = "Set to 0 to force delete"
}

variable "std_map" {
  type = object({
    name_replace_regex   = string
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}
