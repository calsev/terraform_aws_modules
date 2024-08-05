variable "detector_map" {
  type = map(object({
    detect_ec2_ebs_malware_enabled      = optional(bool)
    detect_kubernetes_audit_log_enabled = optional(bool)
    detect_s3_log_enabled               = optional(bool)
    finding_publishing_frequency        = optional(string)
    is_enabled                          = optional(bool)
    name_append                         = optional(bool)
    name_include_app_fields             = optional(bool)
    name_infix                          = optional(bool)
    name_prepend                        = optional(bool)
  }))
}

variable "detector_detect_ec2_ebs_malware_enabled_default" {
  type    = bool
  default = true
}

variable "detector_detect_kubernetes_audit_log_enabled_default" {
  type    = bool
  default = true
}

variable "detector_detect_s3_log_enabled_default" {
  type    = bool
  default = true
}

variable "detector_finding_publishing_frequency_default" {
  type    = string
  default = "SIX_HOURS"
  validation {
    condition     = contains(["FIFTEEN_MINUTES", "ONE_HOUR", "SIX_HOURS"], var.detector_finding_publishing_frequency_default)
    error_message = "Invalid finding publishing frequency"
  }
}

variable "detector_is_enabled_default" {
  type    = bool
  default = true
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
  description = "Prepended before key"
}

variable "std_map" {
  type = object({
    name_replace_regex   = string
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}
