variable "domain_to_dns_zone_map" {
  type = map(object({
    logging_enabled    = optional(bool)
    log_retention_days = optional(number)
    mx_url_list        = optional(list(string))
  }))
}

variable "domain_logging_enabled_default" {
  type        = bool
  default     = true
  description = "A medium-severity security finding if disabled"
}

variable "domain_mx_url_list_default" {
  type        = list(string)
  default     = null
  description = "Set to null to disable MX records"
}

variable "log_retention_days_default" {
  type        = number
  default     = 3
  description = "This is for DNS logs, so typically kept short"
  validation {
    condition     = contains([0, 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653], var.log_retention_days_default)
    error_message = "Log retention must be one of a set of allowed values"
  }
}

{{ std.map() }}

variable "ttl_mx" {
  type    = number
  default = 3600
}
