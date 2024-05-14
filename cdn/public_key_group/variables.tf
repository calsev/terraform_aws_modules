variable "group_map" {
  type = map(object({
    key_key_list            = list(string)
    name_include_app_fields = optional(bool)
    name_infix              = optional(bool)
  }))
}

variable "key_data_map" {
  type = map(object({
    key_id = string
  }))
}

variable "name_include_app_fields_default" {
  type        = bool
  default     = false
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
