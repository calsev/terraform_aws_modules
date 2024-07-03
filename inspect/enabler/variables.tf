variable "enabler_map" {
  type = map(object({
    aws_account_id_list = optional(list(string))
    name_append         = optional(string)
    name_infix          = optional(bool)
    name_override       = optional(string)
    name_prepend        = optional(string)
    resource_type_list  = optional(list(string))
  }))
}

variable "enabler_aws_account_id_list_default" {
  type        = list(string)
  default     = null
  description = "Defaults to current account"
}

variable "enabler_resource_type_list_default" {
  type    = list(string)
  default = ["EC2", "ECR", "LAMBDA", "LAMBDA_CODE"]
  validation {
    condition     = length(setsubtract(toset(var.enabler_resource_type_list_default), toset(["EC2", "ECR", "LAMBDA", "LAMBDA_CODE"]))) == 0
    error_message = "Invalid resource types"
  }
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
    aws_account_id       = string
    name_replace_regex   = string
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}
