variable "comms_data" {
  type = object({
    iam_policy_arn_map_mobile_analytics = map(string)
    ses_config_map = map(object({
      name_effective = string
    }))
    ses_domain_map = map(object({
      identity_arn     = string
      mail_from_domain = string
    }))
  })
}

variable "email_map" {
  type = map(object({
    comms_ses_domain_key      = optional(string)
    enabled                   = optional(bool)
    from_username_custom      = optional(string) # Defaults to name_simple
    iam_role_arn_custom       = optional(string)
    name_append               = optional(string)
    name_include_app_fields   = optional(bool)
    name_infix                = optional(bool)
    name_prefix               = optional(string)
    name_prepend              = optional(string)
    name_suffix               = optional(string)
    pinpoint_application_id   = optional(string)
    ses_configuration_set_key = optional(string)
    ses_identity_arn_custom   = optional(string)
  }))
}

variable "email_comms_ses_domain_key_default" {
  type    = string
  default = null
}

variable "email_enabled_default" {
  type    = bool
  default = true
}

variable "email_iam_role_arn_custom_default" {
  type    = string
  default = null
}

variable "email_pinpoint_application_id_default" {
  type    = string
  default = null
}

variable "email_ses_configuration_set_key_default" {
  type    = string
  default = null
}

variable "email_ses_identity_arn_custom_default" {
  type        = string
  default     = null
  description = "Defaults to the identity of the SES domain. Use for individually validated emails addresses."
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
