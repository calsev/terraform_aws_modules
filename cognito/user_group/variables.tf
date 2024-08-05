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
  description = "Prepended before key"
}

variable "pool_map" {
  type = map(object({
    group_map = optional(map(object({
      iam_role_arn            = optional(string)
      name_append             = optional(string)
      name_include_app_fields = optional(bool)
      name_infix              = optional(bool)
      name_override           = optional(string)
      name_prepend            = optional(string)
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
    name_replace_regex   = string
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}
