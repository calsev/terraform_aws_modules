variable "compute_map" {
  type = map(object({
    capacity_type                          = optional(string)
    execute_command_log_encryption_enabled = optional(bool)
    execute_command_log_retention_days     = optional(number)
    kms_key_id_execute_command             = optional(string)
    name_append                            = optional(string)
    name_include_app_fields                = optional(bool)
    name_infix                             = optional(bool)
    name_prefix                            = optional(string)
    name_prepend                           = optional(string)
    name_suffix                            = optional(string)
    service_connect_default_namespace      = optional(string)
  }))
}

variable "compute_capacity_type_default" {
  type    = string
  default = "FARGATE"
  validation {
    condition     = contains(["FARGATE", "FARGATE_SPOT"], var.compute_capacity_type_default)
    error_message = "Invalid capacity type"
  }
}

variable "compute_execute_command_log_encryption_enabled_default" {
  type    = bool
  default = true
}

variable "compute_execute_command_log_retention_days_default" {
  type    = number
  default = 7
}

variable "compute_kms_key_id_execute_command_default" {
  type    = string
  default = null
}

variable "compute_service_connect_default_namespace_default" {
  type    = string
  default = null
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
