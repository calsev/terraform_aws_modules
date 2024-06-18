variable "analyzer_map" {
  type = map(object({
    analyzer_type           = optional(string)
    name_include_app_fields = optional(bool)
    name_infix              = optional(bool)
    unused_access_age       = optional(number)
  }))
}

variable "analyzer_type_default" {
  type    = string
  default = "ACCOUNT"
  validation {
    condition     = contains(["ACCOUNT", "ACCOUNT_UNUSED_ACCESS", "ORGANIZATION", "ORGANIZATION_UNUSED_ACCESS"], var.analyzer_type_default)
    error_message = "Invalid analyzer type"
  }
}

variable "analyzer_unused_access_age_default" {
  type    = number
  default = 180
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
