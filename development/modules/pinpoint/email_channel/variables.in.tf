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
    {{ name.var_item() }}
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

{{ name.var() }}

{{ std.map() }}
