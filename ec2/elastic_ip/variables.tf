variable "ip_map" {
  type = map(object({
    name_include_app_fields = optional(bool)
    name_infix              = optional(bool)
  }))
}

variable "ip_name_include_app_fields_default" {
  type        = bool
  default     = false
  description = "If true, the Terraform project context will be included in the name"
}

variable "ip_name_infix_default" {
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
