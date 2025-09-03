variable "scan_rule_map" {
  type = map(object({
    repository_filter_map = map(object({
      filter      = optional(string)
      filter_type = optional(string)
    }))
    scan_frequency = optional(string)
  }))
  default = {
    scan_all_on_push = {
      repository_filter_map = {
        scan_all = {
          filter      = null
          filter_type = null
        }
      }
      scan_frequency = null
    }
  }
}

variable "scan_rule_filter_default" {
  type    = string
  default = "*"
}

variable "scan_rule_filter_type_default" {
  type    = string
  default = "WILDCARD"
  validation {
    condition     = contains(["WILDCARD"], var.scan_rule_filter_type_default)
    error_message = "Invalid filter type"
  }
}

variable "scan_rule_scan_frequency_default" {
  type    = string
  default = "CONTINUOUS_SCAN"
  validation {
    condition     = contains(["CONTINUOUS_SCAN", "MANUAL", "SCAN_ON_PUSH"], var.scan_rule_scan_frequency_default)
    error_message = "Invalid filter type"
  }
}

variable "scan_type" {
  type        = string
  default     = "ENHANCED"
  description = "BASIC scanning is deprecated"
  validation {
    condition     = contains(["BASIC", "ENHANCED"], var.scan_type)
    error_message = "Invalid scan type"
  }
}
