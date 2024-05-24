variable "name_map" {
  type = map(object({
    name_include_app_fields = optional(bool)
    name_append             = optional(string)
    name_infix              = optional(bool)
    name_override           = optional(string)
    name_prefix             = optional(string)
    name_prepend            = optional(string)
    name_suffix             = optional(string)
    tags                    = optional(map(string))
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

variable "name_prefix_default" {
  type        = string
  default     = ""
  description = "Prepended before context prefix"
}

variable "name_prepend_default" {
  type        = string
  default     = ""
  description = "Prepended after key"
}

variable "name_regex_allow_list" {
  type        = list(string)
  default     = []
  description = "By default, all punctuation is replaced by -"
}

variable "name_suffix_default" {
  type        = string
  default     = ""
  description = "Appended after context suffix"
}

variable "std_map" {
  type = object({
    name_replace_regex   = string
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}

variable "tags_default" {
  type    = map(string)
  default = {}
}
