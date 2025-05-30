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

variable "pool_map" {
  type = map(object({
    group_map = optional(map(object({
      iam_role_arn            = optional(string)
      name_append             = optional(string)
      name_include_app_fields = optional(bool)
      name_infix              = optional(bool)
      name_prefix             = optional(string)
      name_prepend            = optional(string)
      name_suffix             = optional(string)
      precedence              = optional(number)
    })))
    user_pool_id = string
  }))
}

variable "pool_group_map_default" {
  type = map(object({
    iam_role_arn  = optional(string)
    name_override = optional(string)
    precedence    = optional(number)
  }))
  default = {}
}

variable "pool_group_iam_role_arn_default" {
  type    = string
  default = null
}

variable "pool_group_precedence_default" {
  type    = number
  default = null
  validation {
    condition     = var.pool_group_precedence_default == null ? true : var.pool_group_precedence_default >= 0
    error_message = "Invalid group precedence"
  }
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
