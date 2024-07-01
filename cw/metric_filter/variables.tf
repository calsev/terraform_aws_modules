variable "log_data_map" {
  type = map(object({
    name_effective = string
  }))
}

variable "metric_map" {
  type = map(object({
    log_group_key                = optional(string)
    name_append                  = optional(bool)
    name_include_app_fields      = optional(bool)
    name_infix                   = optional(bool)
    name_prepend                 = optional(bool)
    pattern                      = optional(string)
    transformation_default_value = optional(string)
    transformation_dimension_map = optional(map(string))
    transformation_name          = optional(string)
    transformation_namespace     = optional(string)
    transformation_unit          = optional(string)
    transformation_value         = optional(string)
  }))
}

variable "metric_log_group_key_default" {
  type    = string
  default = null
}

variable "metric_pattern_default" {
  type    = string
  default = null
}

variable "metric_transformation_default_value_default" {
  type    = string
  default = "0"
}

variable "metric_transformation_dimension_map_default" {
  type    = map(string)
  default = {}
}

variable "metric_transformation_name_default" {
  type    = string
  default = null
}

variable "metric_transformation_namespace_default" {
  type    = string
  default = null
}

variable "metric_transformation_unit_default" {
  type    = string
  default = null
}

variable "metric_transformation_value_default" {
  type    = string
  default = "1"
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
