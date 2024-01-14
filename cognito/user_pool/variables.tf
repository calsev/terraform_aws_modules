variable "cdn_global_data" {
  type = object({
    domain_cert_map = map(object({
      arn = string
    }))
  })
}

variable "dns_data" {
  type = object({
    domain_to_dns_zone_map = map(object({
      dns_zone_id = string
    }))
    ttl_map = object({
      alias = number
    })
  })
}

variable "pool_map" {
  type = map(object({
    account_recovery_admin_priority                   = optional(number)
    account_recovery_email_priority                   = optional(number)
    account_recovery_phone_priority                   = optional(number)
    advanced_security_mode_enabled                    = optional(bool)
    attribute_require_verification_before_update_list = optional(list(string))
    auto_verified_attributes                          = optional(list(string))
    client_app_map = optional(map(object({
      access_token_validity_minutes                 = optional(number)
      auth_session_validity_minutes                 = optional(number)
      callback_url_list                             = optional(list(string))
      default_redirect_uri                          = optional(string)
      enable_propagate_additional_user_context_data = optional(bool)
      enable_token_revocation                       = optional(bool)
      explicit_auth_flow_list                       = optional(list(string))
      generate_secret                               = optional(bool)
      id_token_validity_minutes                     = optional(number)
      logout_url_list                               = optional(list(string))
      oath_flow_allowed_list                        = optional(list(string))
      oath_flow_enabled                             = optional(bool)
      oath_scope_list                               = optional(list(string))
      read_attribute_list                           = optional(list(string))
      refresh_token_validity_hours                  = optional(number)
      supported_identity_provider_list              = optional(list(string))
      write_attribute_list                          = optional(list(string))
    })))
    deletion_protection                   = optional(bool)
    device_challenge_required_on_new      = optional(bool)
    device_only_remembered_on_user_prompt = optional(bool)
    dns_domain                            = optional(string)
    dns_subdomain                         = optional(string)
    invite_email_message_template         = optional(string)
    invite_email_subject                  = optional(string)
    invite_sms_message_template           = optional(string)
    only_admin_create_user                = optional(bool)
    password_minimum_length               = optional(number)
    password_require_lowercase            = optional(bool)
    password_require_numbers              = optional(bool)
    password_require_symbols              = optional(bool)
    password_require_uppercase            = optional(bool)
    password_temporary_validity_days      = optional(number)
    username_attribute_list               = optional(list(string))
    username_alias_attribute_list         = optional(list(string))
    username_case_sensitive               = optional(bool)
    verify_confirm_with_link              = optional(bool)
    verify_email_message_by_code_template = optional(string)
    verify_email_message_by_link_template = optional(string)
    verify_email_message_by_code_subject  = optional(string)
    verify_email_message_by_link_subject  = optional(string)
    verify_sms_message_template           = optional(string)
  }))
}

variable "pool_account_recovery_admin_priority_default" {
  type        = number
  default     = 3
  description = "Set to null to disable email recovery"
}

variable "pool_account_recovery_email_priority_default" {
  type        = number
  default     = 1
  description = "Set to null to disable email recovery"
}

variable "pool_account_recovery_phone_priority_default" {
  type        = number
  default     = 2
  description = "Set to null to disable email recovery"
}

variable "pool_advanced_security_mode_enabled_default" {
  type    = bool
  default = true
}

variable "pool_attribute_require_verification_before_update_list_default" {
  type    = list(string)
  default = ["email", ] # TODO: "phone_number"
}

variable "pool_auto_verified_attributes_default" {
  type    = list(string)
  default = ["email", ] # TODO: "phone_number"
}

variable "pool_client_app_map_default" {
  type = map(object({
    access_token_validity_minutes                 = optional(number)
    auth_session_validity_minutes                 = optional(number)
    callback_url_list                             = optional(list(string))
    default_redirect_uri                          = optional(string)
    enable_propagate_additional_user_context_data = optional(bool)
    enable_token_revocation                       = optional(bool)
    explicit_auth_flow_list                       = optional(list(string))
    generate_secret                               = optional(bool)
    id_token_validity_minutes                     = optional(number)
    logout_url_list                               = optional(list(string))
    oath_flow_allowed_list                        = optional(list(string))
    oath_flow_enabled                             = optional(bool)
    oath_scope_list                               = optional(list(string))
    read_attribute_list                           = optional(list(string))
    refresh_token_validity_hours                  = optional(number)
    supported_identity_provider_list              = optional(list(string))
    write_attribute_list                          = optional(list(string))
  }))
  default = {}
}

variable "pool_deletion_protection_default" {
  type    = bool
  default = true
}

variable "pool_device_challenge_required_on_new_default" {
  type    = bool
  default = true
}

variable "pool_device_only_remembered_on_user_prompt_default" {
  type    = bool
  default = true
}

variable "pool_dns_domain_default" {
  type    = string
  default = null
}

variable "pool_dns_subdomain_default" {
  type    = string
  default = "cognito"
}

variable "pool_invite_email_message_template_default" {
  type    = string
  default = "Username is '{username}' and temporary password is {####}"
  validation {
    condition     = strcontains(var.pool_invite_email_message_template_default, "{username}") && strcontains(var.pool_invite_email_message_template_default, "{####}")
    error_message = "Template must contain placeholders for username and temporary password"
  }
}

variable "pool_invite_email_subject_default" {
  type    = string
  default = "Login credentials"
}

variable "pool_invite_sms_message_template_default" {
  type    = string
  default = "Username is '{username}' and temporary password is {####}"
  validation {
    condition     = strcontains(var.pool_invite_sms_message_template_default, "{username}") && strcontains(var.pool_invite_sms_message_template_default, "{####}")
    error_message = "Template must contain placeholders for username and temporary password"
  }
}

variable "pool_only_admin_create_user_default" {
  type    = bool
  default = true
}

variable "pool_password_minimum_length_default" {
  type    = number
  default = 16
}

variable "pool_password_require_lowercase_default" {
  type    = bool
  default = false
}

variable "pool_password_require_numbers_default" {
  type    = bool
  default = false
}

variable "pool_password_require_symbols_default" {
  type    = bool
  default = false
}

variable "pool_password_require_uppercase_default" {
  type    = bool
  default = false
}

variable "pool_password_temporary_validity_days_default" {
  type    = number
  default = 7
}

variable "pool_username_alias_attribute_list_default" {
  type    = list(string)
  default = null
}

variable "pool_username_attribute_list_default" {
  type    = list(string)
  default = null
}

variable "pool_username_case_sensitive_default" {
  type    = bool
  default = true
}

variable "pool_verify_confirm_with_link_default" {
  type    = bool
  default = true
}

variable "pool_verify_email_message_by_code_template_default" {
  type    = string
  default = "Here is your verification code: {####}"
  validation {
    condition     = strcontains(var.pool_verify_email_message_by_code_template_default, "{####}")
    error_message = "Template must contain placeholder for code"
  }
}

variable "pool_verify_email_message_by_link_template_default" {
  type    = string
  default = "To verify your email address click on this link: {##Click Here##}"
  validation {
    condition     = strcontains(var.pool_verify_email_message_by_link_template_default, "{##Click Here##}")
    error_message = "Template must contain placeholder for code"
  }
}

variable "pool_verify_email_message_by_code_subject_default" {
  type    = string
  default = "Verify email"
}

variable "pool_verify_email_message_by_link_subject_default" {
  type    = string
  default = "Verify email"
}

variable "pool_verify_sms_message_template_default" {
  type    = string
  default = "Here is your verification code: {####}"
  validation {
    condition     = strcontains(var.pool_verify_sms_message_template_default, "{####}")
    error_message = "Template must contain placeholder for code"
  }
}

variable "std_map" {
  type = object({
    aws_region_name      = string
    name_replace_regex   = string
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}
