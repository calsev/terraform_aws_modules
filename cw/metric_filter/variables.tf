variable "log_data_map" {
  type = map(object({
    name_effective = string
  }))
}

variable "metric_map" {
  type = map(object({
    log_group_key                = optional(string)
    name_append                  = optional(string)
    name_include_app_fields      = optional(bool)
    name_infix                   = optional(bool)
    name_prefix                  = optional(string)
    name_prepend                 = optional(string)
    name_suffix                  = optional(string)
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
  description = "If true, standard project context will be prefixed to the name. Ignored if not name_infix."
}

variable "name_infix_default" {
  type        = bool
  default     = true
  description = "If true, standard project prefix and resource suffix will be added to the name"
}

variable "name_prefix_default" {
  type        = string
  default     = ""
  description = "Prepended before context prefix"
}

variable "name_prepend_default" {
  type        = string
  default     = ""
  description = "Prepended before key"
}

# tflint-ignore: terraform_unused_declarations
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
    access_title_map               = map(string)
    aws_account_id                 = string
    aws_region_name                = string
    config_name                    = string
    env                            = string
    iam_partition                  = string
    name_replace_regex             = string
    resource_name_prefix           = string
    resource_name_suffix           = string
    service_resource_access_action = map(map(map(list(string))))
    tags                           = map(string)
  })
}
