variable "resource_map" {
  type = map(object({
    name_append   = optional(string)
    name_infix    = optional(bool)
    name_override = optional(string)
    name_prepend  = optional(string)
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
  description = "Prepended after key"
}

variable "std_map" {
  type = object({
    name_replace_regex   = string
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}
