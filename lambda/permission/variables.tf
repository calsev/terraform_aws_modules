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
  description = "Prepended before key"
}

variable "name_suffix_default" {
  type        = string
  default     = ""
  description = "Appended after context suffix"
}

variable "permission_map" {
  type = map(object({
    action                  = optional(string)
    lambda_arn              = optional(string) # If null will be omitted
    name_append             = optional(string)
    name_include_app_fields = optional(bool)
    name_infix              = optional(bool)
    name_prefix             = optional(string)
    name_prepend            = optional(string)
    name_suffix             = optional(string)
    principal               = optional(string)
    qualifier               = optional(string)
    source_arn              = optional(string)
  }))
}

variable "permission_action_default" {
  type    = string
  default = "lambda:InvokeFunction"
}

variable "permission_principal_default" {
  type        = string
  default     = null
  description = "Typically the service, e.g. events.amazonaws.com"
}

variable "permission_qualifier_default" {
  type    = string
  default = null
}

variable "permission_source_arn_default" {
  type    = string
  default = null
}

variable "std_map" {
  type = object({
    aws_account_id       = string
    name_replace_regex   = string
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}
