variable "deployment_map" {
  type = map(object({
    compute_platform        = optional(string)
    name_include_app_fields = optional(bool)
    name_infix              = optional(bool)
  }))
}

variable "deployment_compute_platform_default" {
  type    = string
  default = null
  validation {
    condition     = contains(["ECS", "Lambda", "Server"], var.deployment_compute_platform_default)
    error_message = "Invalid compute platform"
  }
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

variable "std_map" {
  type = object({
    name_replace_regex   = string
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}
