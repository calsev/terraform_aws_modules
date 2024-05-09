variable "group_map" {
  type = map(object({
    family                  = optional(string)
    name_include_app_fields = optional(bool)
    name_infix              = optional(bool)
    parameter_map           = optional(map(string))
  }))
}

variable "group_family_default" {
  type    = string
  default = "redis7"
}

variable "group_parameter_map_default" {
  type    = map(string)
  default = {}
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
