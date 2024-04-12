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
  type    = number
  default = 180
}

variable "length_min" {
  type    = number
  default = 16
}

variable "require_lowercase_character" {
  type    = bool
  default = false
}

variable "require_number" {
  type    = bool
  default = false
}

variable "require_symbol" {
  type    = bool
  default = false
}

variable "require_uppercase_character" {
  type    = bool
  default = false
}

variable "reuse_prevention_password_count" {
  type    = number
  default = 6
}
