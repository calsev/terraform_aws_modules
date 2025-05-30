variable "allow_users_to_change_password" {
  type    = bool
  default = true
}

variable "admin_reset_after_expiration" {
  type        = bool
  default     = false
  description = "If false, users must change their own password on first login after expiration"
}

variable "age_max_days" {
  type        = number
  default     = 90
  description = "Less than 180 will be a medium-severity finding - less than 90 will be a finding under PCI DSS"
}

variable "length_min" {
  type        = number
  default     = 16
  description = "Less than 12 will be a finding in some security frameworks, less than 14 in others."
}

variable "require_lowercase_character" {
  type        = bool
  default     = true
  description = "If disabled this will be a medium-level security finding"
}

variable "require_number" {
  type        = bool
  default     = true
  description = "If disabled this will be a medium-level security finding"
}

variable "require_symbol" {
  type        = bool
  default     = true
  description = "If disabled this will be a medium-level security finding"
}

variable "require_uppercase_character" {
  type        = bool
  default     = true
  description = "If disabled this will be a medium-level security finding"
}

variable "reuse_prevention_password_count" {
  type        = number
  default     = 24
  description = "Less than 6 will be a medium-level finding, less than 24 will be low-severity security finding"
}
