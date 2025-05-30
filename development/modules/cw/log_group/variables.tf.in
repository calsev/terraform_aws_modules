variable "log_map" {
  type = map(object({
    allow_public_read       = optional(bool)
    kms_key_id              = optional(string)
    log_group_class         = optional(string)
    log_retention_days      = optional(number)
    {{ name.var_item() }}
    policy_create           = optional(bool)
    policy_name_append      = optional(string)
    skip_destroy            = optional(bool)
  }))
}

variable "log_allow_public_read_default" {
  type    = bool
  default = false
}

variable "log_group_class_default" {
  type    = string
  default = "STANDARD"
  validation {
    condition     = contains(["INFREQUENT_ACCESS", "STANDARD"], var.log_group_class_default)
    error_message = "Invalid log group class"
  }
}

variable "log_kms_key_id_default" {
  type    = string
  default = null
}

variable "log_retention_days_default" {
  type    = number
  default = 14
  validation {
    condition     = contains([0, 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653], var.log_retention_days_default)
    error_message = "Log retention must be one of a set of allowed values"
  }
}

variable "log_skip_destroy_default" {
  type    = bool
  default = false
}

{{ name.var() }}

{{ iam.policy_var_ar(access=["read", "write"], append="log") }}

{{ std.map() }}
