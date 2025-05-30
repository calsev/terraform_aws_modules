variable "archive_retention_days_for_default_bus" {
  type    = number
  default = 3
}

variable "logging_enabled_for_default_bus" {
  type    = bool
  default = true
}

variable "log_retention_days_for_default_bus" {
  type    = number
  default = 3
}

{{ std.map() }}
