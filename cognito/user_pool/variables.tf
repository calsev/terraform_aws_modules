variable "cdn_global_data" {
  type = object({
    domain_cert_map = map(object({
      certificate_arn = string
    }))
  })
}

variable "comms_data" {
  type = object({
    ses_email_map = map(object({
      configuration_set_name = string
      identity_arn           = string
    }))
  })
  default     = null
  description = "Must be provided if any pool uses SES email"
}

variable "dns_data" {
  type = object({
    domain_to_dns_zone_map = map(object({
      dns_zone_id = string
    }))
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
    deletion_protection                       = optional(bool)
    device_challenge_required_on_new          = optional(bool)
    device_only_remembered_on_user_prompt     = optional(bool)
    dns_from_zone_key                         = optional(string)
    dns_subdomain                             = optional(string)
    email_from_username                       = optional(string)
    email_reply_to_address                    = optional(string)
    email_ses_key                             = optional(string)
    invite_email_message_template             = optional(string)
    invite_email_subject                      = optional(string)
    invite_sms_message_template               = optional(string)
    lambda_arn_create_auth_challenge          = optional(string)
    lambda_arn_custom_message                 = optional(string)
    lambda_arn_define_auth_challenge          = optional(string)
    lambda_arn_pre_authentication             = optional(string)
    lambda_arn_pre_sign_up                    = optional(string)
    lambda_arn_pre_token_generation           = optional(string)
    lambda_arn_post_authentication            = optional(string)
    lambda_arn_post_confirmation              = optional(string)
    lambda_arn_user_migration                 = optional(string)
    lambda_arn_verify_auth_challenge_response = optional(string)
    lambda_kms_key_id                         = optional(string)
    mfa_configuration                         = optional(string)
    mfa_software_token_enabled                = optional(bool)
    only_admin_create_user                    = optional(bool)
    password_minimum_length                   = optional(number)
    password_require_lowercase                = optional(bool)
    password_require_numbers                  = optional(bool)
    password_require_symbols                  = optional(bool)
    password_require_uppercase                = optional(bool)
    password_temporary_validity_days          = optional(number)
    schema_map = optional(map(object({
      data_type         = optional(string)
      is_developer_only = optional(bool)
      is_mutable        = optional(bool)
      is_required       = optional(bool)
      number_value_max  = optional(number)
      number_value_min  = optional(number)
      string_length_max = optional(number)
      string_length_min = optional(number)
    })))
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

variable "pool_dns_from_zone_key_default" {
  type    = string
  default = null
}

variable "pool_dns_subdomain_default" {
  type    = string
  default = "cognito"
}

variable "pool_email_from_username_default" {
  type    = string
  default = null
}

variable "pool_email_reply_to_address_default" {
  type    = string
  default = null
}

variable "pool_email_ses_key_default" {
  type    = string
  default = null
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
  type        = string
  default     = null
  description = "Defaults to 'Login credentials from email_from_username'"
}

variable "pool_invite_sms_message_template_default" {
  type    = string
  default = "Username is '{username}' and temporary password is {####}"
  validation {
    condition     = strcontains(var.pool_invite_sms_message_template_default, "{username}") && strcontains(var.pool_invite_sms_message_template_default, "{####}")
    error_message = "Template must contain placeholders for username and temporary password"
  }
}

variable "pool_lambda_arn_create_auth_challenge_default" {
  type    = string
  default = null
}

variable "pool_lambda_arn_custom_message_default" {
  type    = string
  default = null
}

variable "pool_lambda_arn_define_auth_challenge_default" {
  type    = string
  default = null
}

variable "pool_lambda_arn_post_authentication_default" {
  type    = string
  default = null
}

variable "pool_lambda_arn_post_confirmation_default" {
  type    = string
  default = null
}

variable "pool_lambda_arn_pre_authentication_default" {
  type    = string
  default = null
}

variable "pool_lambda_arn_pre_sign_up_default" {
  type    = string
  default = null
}

variable "pool_lambda_arn_pre_token_generation_default" {
  type    = string
  default = null
}

variable "pool_lambda_arn_user_migration_default" {
  type    = string
  default = null
}

variable "pool_lambda_arn_verify_auth_challenge_response_default" {
  type    = string
  default = null
}

variable "pool_lambda_kms_key_id_default" {
  type    = string
  default = null
}

variable "pool_mfa_configuration_default" {
  type        = string
  default     = "OPTIONAL"
  description = "Requires an MFA method to be configured"
  validation {
    condition     = contains(["OFF", "ON", "OPTIONAL"], var.pool_mfa_configuration_default)
    error_message = "Invalid MFA configuration"
  }
}

variable "pool_mfa_software_token_enabled_default" {
  type    = bool
  default = true
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

variable "pool_schema_map_default" {
  type = map(object({
    data_type         = optional(string)
    is_developer_only = optional(bool)
    is_mutable        = optional(bool)
    is_required       = optional(bool)
    number_value_max  = optional(number)
    number_value_min  = optional(number)
    string_length_max = optional(number)
    string_length_min = optional(number)
  }))
  default = {}
}

variable "pool_schema_data_type_default" {
  type    = string
  default = "String"
  validation {
    condition     = contains(["Boolean", "DateTime", "Number", "String"], var.pool_schema_data_type_default)
    error_message = "Invalid schema data type"
  }
}

variable "pool_schema_is_developer_only_default" {
  type    = bool
  default = false
}

variable "pool_schema_is_mutable_default" {
  type    = bool
  default = true
}

variable "pool_schema_is_required_default" {
  type        = bool
  default     = false
  description = "Supported only for standard attributes"
}

variable "pool_schema_number_value_max_default" {
  type    = number
  default = null
}

variable "pool_schema_number_value_min_default" {
  type    = number
  default = null
}

variable "pool_schema_string_length_max_default" {
  type    = number
  default = null
}

variable "pool_schema_string_length_min_default" {
  type    = number
  default = null
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
  default = false
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
    aws_account_id       = string
    aws_region_name      = string
    name_replace_regex   = string
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}
