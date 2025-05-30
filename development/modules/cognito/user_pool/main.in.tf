resource "aws_cognito_user_pool" "this_pool" {
  for_each = local.lx_map
  account_recovery_setting {
    dynamic "recovery_mechanism" {
      for_each = each.value.account_recovery_map
      content {
        name     = recovery_mechanism.key
        priority = recovery_mechanism.value
      }
    }
  }
  admin_create_user_config {
    allow_admin_create_user_only = each.value.only_admin_create_user
    invite_message_template {
      email_message = each.value.invite_email_message_template
      email_subject = each.value.invite_email_subject
      sms_message   = each.value.invite_sms_message_template
    }
  }
  alias_attributes         = each.value.username_alias_attribute_list
  auto_verified_attributes = each.value.auto_verified_attributes
  deletion_protection      = each.value.deletion_protection ? "ACTIVE" : "INACTIVE"
  device_configuration {
    challenge_required_on_new_device      = each.value.device_challenge_required_on_new
    device_only_remembered_on_user_prompt = each.value.device_only_remembered_on_user_prompt
  }
  email_configuration {
    configuration_set      = each.value.email_ses_configuration_set_name
    email_sending_account  = each.value.email_ses_key == null ? "COGNITO_DEFAULT" : "DEVELOPER"
    from_email_address     = each.value.email_from_full
    reply_to_email_address = each.value.email_reply_to_address
    source_arn             = each.value.email_ses_identity_arn
  }
  email_verification_message = null # Conflicts with verification_message_template
  email_verification_subject = null # Conflicts with verification_message_template
  dynamic "lambda_config" {
    for_each = each.value.lambda_has_config ? { this = {} } : {}
    content {
      create_auth_challenge = each.value.lambda_arn_create_auth_challenge
      # custom_email_sender # TODO
      custom_message = each.value.lambda_arn_custom_message
      # custom_sms_sender # TODO
      define_auth_challenge          = each.value.lambda_arn_define_auth_challenge
      kms_key_id                     = each.value.lambda_kms_key_id
      pre_authentication             = each.value.lambda_arn_pre_authentication
      pre_sign_up                    = each.value.lambda_arn_pre_sign_up
      pre_token_generation           = each.value.lambda_arn_pre_token_generation
      post_authentication            = each.value.lambda_arn_post_authentication
      post_confirmation              = each.value.lambda_arn_post_confirmation
      user_migration                 = each.value.lambda_arn_user_migration
      verify_auth_challenge_response = each.value.lambda_arn_verify_auth_challenge_response
    }
  }
  mfa_configuration = each.value.mfa_configuration
  name              = each.value.name_effective
  password_policy {
    minimum_length                   = each.value.password_minimum_length
    require_lowercase                = each.value.password_require_lowercase
    require_numbers                  = each.value.password_require_numbers
    require_symbols                  = each.value.password_require_symbols
    require_uppercase                = each.value.password_require_uppercase
    temporary_password_validity_days = each.value.password_temporary_validity_days
  }
  dynamic "schema" {
    for_each = each.value.schema_map
    content {
      attribute_data_type      = schema.value.data_type
      developer_only_attribute = schema.value.is_developer_only
      mutable                  = schema.value.is_mutable
      name                     = schema.key
      dynamic "number_attribute_constraints" {
        for_each = schema.value.data_type == "Number" ? { this = {} } : {}
        content {
          max_value = schema.value.number_value_max
          min_value = schema.value.number_value_min
        }
      }
      required = schema.value.is_required
      dynamic "string_attribute_constraints" {
        for_each = schema.value.data_type == "String" ? { this = {} } : {}
        content {
          max_length = schema.value.string_length_max
          min_length = schema.value.string_length_min
        }
      }
    }
  }
  sms_authentication_message = null # TODO
  # sms_configuration # TODO
  sms_verification_message = null # Conflicts with verification_message_template
  software_token_mfa_configuration {
    enabled = each.value.mfa_software_token_enabled
  }
  tags                = each.value.tags
  username_attributes = each.value.username_attribute_list
  user_attribute_update_settings {
    attributes_require_verification_before_update = each.value.attribute_require_verification_before_update_list
  }
  user_pool_add_ons {
    advanced_security_mode = each.value.advanced_security_mode_enabled ? "ENFORCED" : "OFF" # AUDIT?
  }
  username_configuration {
    case_sensitive = each.value.username_case_sensitive
  }
  verification_message_template {
    default_email_option  = each.value.verify_confirm_with_link ? "CONFIRM_WITH_LINK" : "CONFIRM_WITH_CODE"
    email_message         = each.value.verify_email_message_by_code_template
    email_message_by_link = each.value.verify_email_message_by_link_template
    email_subject         = each.value.verify_email_message_by_code_subject
    email_subject_by_link = each.value.verify_email_message_by_link_subject
    sms_message           = each.value.verify_sms_message_template
  }
}

module "lambda_permission" {
  source                       = "../../lambda/permission"
  for_each                     = local.create_lambda_permission_x_map
  permission_map               = each.value
  permission_principal_default = "cognito-idp.amazonaws.com"
  std_map                      = var.std_map
}

resource "aws_cognito_user_pool_domain" "domain" {
  for_each        = local.create_domain_map
  certificate_arn = each.value.acm_certificate_arn
  domain          = each.value.dns_from_fqdn
  user_pool_id    = aws_cognito_user_pool.this_pool[each.key].id
}

module "domain_alias" {
  source                           = "../../dns/record"
  dns_data                         = var.dns_data
  record_dns_from_zone_key_default = var.pool_dns_from_zone_key_default
  record_map                       = local.create_alias_map
  std_map                          = var.std_map
}

module "pool_client" {
  source                                       = "../../cognito/client_app"
  client_access_token_validity_minutes_default = var.client_access_token_validity_minutes_default
  client_auth_session_validity_minutes_default = var.client_auth_session_validity_minutes_default
  client_id_token_validity_minutes_default     = var.client_id_token_validity_minutes_default
  client_refresh_token_validity_hours_default  = var.client_refresh_token_validity_hours_default
  pool_map                                     = local.create_client_map
  std_map                                      = var.std_map
}

module "pool_group" {
  source                          = "../../cognito/user_group"
  name_append_default             = var.name_append_default
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_prepend_default            = var.name_prepend_default
  pool_group_map_default          = var.pool_group_map_default
  pool_group_iam_role_arn_default = var.pool_group_iam_role_arn_default
  pool_group_precedence_default   = var.pool_group_precedence_default
  pool_map                        = local.create_client_map
  std_map                         = var.std_map
}
