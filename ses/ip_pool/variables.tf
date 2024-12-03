variable "pool_map" {
  type = map(object({
    name_append             = optional(string)
    name_include_app_fields = optional(bool)
    name_infix              = optional(bool)
    name_override           = optional(string)
    name_prepend            = optional(string)
    scaling_mode            = optional(string)
  }))
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

variable "pool_scaling_mode_default" {
  type    = string
  default = "MANAGED"
  validation {
    condition     = contains(["MANAGED", "STANDARD"], var.pool_scaling_mode_default)
    error_message = "Invalid scaling mode"
  }
}

variable "std_map" {
  type = object({
    name_replace_regex   = string
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}
