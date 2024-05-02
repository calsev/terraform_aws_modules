module "name_map" {
  source   = "../../name_map"
  name_map = var.pool_map
  std_map  = var.std_map
}

locals {
  create_alias_map = {
    for k, v in local.lx_map : k => merge(v, {
      dns_alias_name    = aws_cognito_user_pool_domain.domain[k].cloudfront_distribution
      dns_alias_zone_id = aws_cognito_user_pool_domain.domain[k].cloudfront_distribution_zone_id
    }) if v.dns_from_fqdn != null
  }
  create_client_map = {
    for k_pool, v_pool in local.lx_map : k_pool => merge(v_pool, {
      user_pool_id = aws_cognito_user_pool.this_pool[k_pool].id
    })
  }
  create_domain_map = {
    for k, v in local.lx_map : k => v if v.dns_from_fqdn != null
  }
  create_lambda_permission_1_map = {
    for k, v in local.lx_map : k => merge(v, {
      name_prefix = "cognito_${k}_"
      permission_map = {
        create_auth_challenge          = v.lambda_arn_create_auth_challenge
        custom_message                 = v.lambda_arn_custom_message
        define_auth_challenge          = v.lambda_arn_define_auth_challenge
        pre_authentication             = v.lambda_arn_pre_authentication
        pre_sign_up                    = v.lambda_arn_pre_sign_up
        pre_token_generation           = v.lambda_arn_pre_token_generation
        post_authentication            = v.lambda_arn_post_authentication
        post_confirmation              = v.lambda_arn_post_confirmation
        user_migration                 = v.lambda_arn_user_migration
        verify_auth_challenge_response = v.lambda_arn_verify_auth_challenge_response
      }
      source_arn = aws_cognito_user_pool.this_pool[k].arn
    })
  }
  create_lambda_permission_x_map = {
    for k, v in local.create_lambda_permission_1_map : k => {
      for k_perm, arn_perm in v.permission_map : k_perm => merge(v, {
        lambda_arn = arn_perm
      })
    }
  }
  l1_map = {
    for k, v in var.pool_map : k => merge(v, module.name_map.data[k], {
      account_recovery_admin_priority                   = v.account_recovery_admin_priority == null ? var.pool_account_recovery_admin_priority_default : v.account_recovery_admin_priority
      account_recovery_email_priority                   = v.account_recovery_email_priority == null ? var.pool_account_recovery_email_priority_default : v.account_recovery_email_priority
      account_recovery_phone_priority                   = v.account_recovery_phone_priority == null ? var.pool_account_recovery_phone_priority_default : v.account_recovery_phone_priority
      advanced_security_mode_enabled                    = v.advanced_security_mode_enabled == null ? var.pool_advanced_security_mode_enabled_default : v.advanced_security_mode_enabled
      attribute_require_verification_before_update_list = v.attribute_require_verification_before_update_list == null ? var.pool_attribute_require_verification_before_update_list_default : v.attribute_require_verification_before_update_list
      auto_verified_attributes                          = v.auto_verified_attributes == null ? var.pool_auto_verified_attributes_default : v.auto_verified_attributes
      client_app_map                                    = v.client_app_map == null ? var.pool_client_app_map_default : v.client_app_map
      deletion_protection                               = v.deletion_protection == null ? var.pool_deletion_protection_default : v.deletion_protection
      device_challenge_required_on_new                  = v.device_challenge_required_on_new == null ? var.pool_device_challenge_required_on_new_default : v.device_challenge_required_on_new
      device_only_remembered_on_user_prompt             = v.device_only_remembered_on_user_prompt == null ? var.pool_device_only_remembered_on_user_prompt_default : v.device_only_remembered_on_user_prompt
      email_from_username                               = v.email_from_username == null ? var.pool_email_from_username_default : v.email_from_username
      email_reply_to_address                            = v.email_reply_to_address == null ? var.pool_email_reply_to_address_default : v.email_reply_to_address
      email_ses_key                                     = v.email_ses_key == null ? var.pool_email_ses_key_default : v.email_ses_key
      invite_email_message_template                     = v.invite_email_message_template == null ? var.pool_invite_email_message_template_default : v.invite_email_message_template
      invite_sms_message_template                       = v.invite_sms_message_template == null ? var.pool_invite_sms_message_template_default : v.invite_sms_message_template
      lambda_arn_create_auth_challenge                  = v.lambda_arn_create_auth_challenge == null ? var.pool_lambda_arn_create_auth_challenge_default : v.lambda_arn_create_auth_challenge
      lambda_arn_custom_message                         = v.lambda_arn_custom_message == null ? var.pool_lambda_arn_custom_message_default : v.lambda_arn_custom_message
      lambda_arn_define_auth_challenge                  = v.lambda_arn_define_auth_challenge == null ? var.pool_lambda_arn_define_auth_challenge_default : v.lambda_arn_define_auth_challenge
      lambda_arn_pre_authentication                     = v.lambda_arn_pre_authentication == null ? var.pool_lambda_arn_pre_authentication_default : v.lambda_arn_pre_authentication
      lambda_arn_pre_sign_up                            = v.lambda_arn_pre_sign_up == null ? var.pool_lambda_arn_pre_sign_up_default : v.lambda_arn_pre_sign_up
      lambda_arn_pre_token_generation                   = v.lambda_arn_pre_token_generation == null ? var.pool_lambda_arn_pre_token_generation_default : v.lambda_arn_pre_token_generation
      lambda_arn_post_authentication                    = v.lambda_arn_post_authentication == null ? var.pool_lambda_arn_post_authentication_default : v.lambda_arn_post_authentication
      lambda_arn_post_confirmation                      = v.lambda_arn_post_confirmation == null ? var.pool_lambda_arn_post_confirmation_default : v.lambda_arn_post_confirmation
      lambda_arn_user_migration                         = v.lambda_arn_user_migration == null ? var.pool_lambda_arn_user_migration_default : v.lambda_arn_user_migration
      lambda_arn_verify_auth_challenge_response         = v.lambda_arn_verify_auth_challenge_response == null ? var.pool_lambda_arn_verify_auth_challenge_response_default : v.lambda_arn_verify_auth_challenge_response
      lambda_kms_key_id                                 = v.lambda_kms_key_id == null ? var.pool_lambda_kms_key_id_default : v.lambda_kms_key_id
      mfa_configuration                                 = v.mfa_configuration == null ? var.pool_mfa_configuration_default : v.mfa_configuration
      mfa_software_token_enabled                        = v.mfa_software_token_enabled == null ? var.pool_mfa_software_token_enabled_default : v.mfa_software_token_enabled
      only_admin_create_user                            = v.only_admin_create_user == null ? var.pool_only_admin_create_user_default : v.only_admin_create_user
      password_minimum_length                           = v.password_minimum_length == null ? var.pool_password_minimum_length_default : v.password_minimum_length
      password_require_lowercase                        = v.password_require_lowercase == null ? var.pool_password_require_lowercase_default : v.password_require_lowercase
      password_require_numbers                          = v.password_require_numbers == null ? var.pool_password_require_numbers_default : v.password_require_numbers
      password_require_symbols                          = v.password_require_symbols == null ? var.pool_password_require_symbols_default : v.password_require_symbols
      password_require_uppercase                        = v.password_require_uppercase == null ? var.pool_password_require_uppercase_default : v.password_require_uppercase
      password_temporary_validity_days                  = v.password_temporary_validity_days == null ? var.pool_password_temporary_validity_days_default : v.password_temporary_validity_days
      schema_map                                        = v.schema_map == null ? var.pool_schema_map_default : v.schema_map
      username_alias_attribute_list                     = v.username_alias_attribute_list == null ? var.pool_username_alias_attribute_list_default : v.username_alias_attribute_list
      username_attribute_list                           = v.username_attribute_list == null ? var.pool_username_attribute_list_default : v.username_attribute_list
      username_case_sensitive                           = v.username_case_sensitive == null ? var.pool_username_case_sensitive_default : v.username_case_sensitive
      verify_confirm_with_link                          = v.verify_confirm_with_link == null ? var.pool_verify_confirm_with_link_default : v.verify_confirm_with_link
      verify_email_message_by_code_template             = v.verify_email_message_by_code_template == null ? var.pool_verify_email_message_by_code_template_default : v.verify_email_message_by_code_template
      verify_email_message_by_link_template             = v.verify_email_message_by_link_template == null ? var.pool_verify_email_message_by_link_template_default : v.verify_email_message_by_link_template
      verify_email_message_by_code_subject              = v.verify_email_message_by_code_subject == null ? var.pool_verify_email_message_by_code_subject_default : v.verify_email_message_by_code_subject
      verify_email_message_by_link_subject              = v.verify_email_message_by_link_subject == null ? var.pool_verify_email_message_by_link_subject_default : v.verify_email_message_by_link_subject
      verify_sms_message_template                       = v.verify_sms_message_template == null ? var.pool_verify_sms_message_template_default : v.verify_sms_message_template
      dns_from_zone_key                                 = v.dns_from_zone_key == null ? var.pool_dns_from_zone_key_default : v.dns_from_zone_key
      dns_subdomain                                     = v.dns_subdomain == null ? var.pool_dns_subdomain_default : v.dns_subdomain
    })
  }
  l2_map = {
    for k, v in var.pool_map : k => {
      account_recovery_map = merge(
        # There is a maximum of 2, so disable admin if two factors are configured
        local.l1_map[k].account_recovery_admin_priority == null ? null : local.l1_map[k].account_recovery_email_priority != null && local.l1_map[k].account_recovery_phone_priority != null ? null : {
          admin_only = local.l1_map[k].account_recovery_admin_priority
        },
        local.l1_map[k].account_recovery_email_priority == null ? null : {
          verified_email = local.l1_map[k].account_recovery_email_priority
        },
        local.l1_map[k].account_recovery_phone_priority == null ? null : {
          verified_phone_number = local.l1_map[k].account_recovery_phone_priority
        },
      )
      email_from_full                  = local.l1_map[k].email_ses_key == null ? null : local.l1_map[k].email_from_username == null ? local.l1_map[k].email_ses_key : "${local.l1_map[k].email_from_username} <${local.l1_map[k].email_ses_key}>"
      email_ses_configuration_set_name = local.l1_map[k].email_ses_key == null ? null : var.comms_data.ses_email_map[local.l1_map[k].email_ses_key].configuration_set_name
      email_ses_identity_arn           = local.l1_map[k].email_ses_key == null ? null : var.comms_data.ses_email_map[local.l1_map[k].email_ses_key].identity_arn
      dns_from_fqdn                    = local.l1_map[k].dns_from_zone_key == null ? null : "${local.l1_map[k].dns_subdomain}.${local.l1_map[k].dns_from_zone_key}"
      invite_email_subject             = v.invite_email_subject == null ? var.pool_invite_email_subject_default == null ? local.l1_map[k].email_from_username == null ? "Login credentials" : "Login credentials from ${local.l1_map[k].email_from_username}" : var.pool_invite_email_subject_default : v.invite_email_subject
      lambda_has_config = local.l1_map[k].lambda_arn_create_auth_challenge != null || (
        local.l1_map[k].lambda_arn_custom_message != null || (
          local.l1_map[k].lambda_arn_define_auth_challenge != null || (
            local.l1_map[k].lambda_arn_pre_authentication != null || (
              local.l1_map[k].lambda_arn_pre_sign_up != null || (
                local.l1_map[k].lambda_arn_pre_token_generation != null || (
                  local.l1_map[k].lambda_arn_post_authentication != null || (
                    local.l1_map[k].lambda_arn_post_confirmation != null || (
                      local.l1_map[k].lambda_arn_user_migration != null || (
                        local.l1_map[k].lambda_arn_verify_auth_challenge_response != null || (
                          local.l1_map[k].lambda_kms_key_id != null
                        )
                      )
                    )
                  )
                )
              )
            )
          )
        )
      )
      schema_map = {
        for k_schema, v_schema in local.l1_map[k].schema_map : k_schema => {
          data_type         = v_schema.data_type == null ? var.pool_schema_data_type_default : v_schema.data_type
          is_developer_only = v_schema.is_developer_only == null ? var.pool_schema_is_developer_only_default : v_schema.is_developer_only
          is_mutable        = v_schema.is_mutable == null ? var.pool_schema_is_mutable_default : v_schema.is_mutable
          is_required       = v_schema.is_required == null ? var.pool_schema_is_required_default : v_schema.is_required
          number_value_max  = v_schema.number_value_max == null ? var.pool_schema_number_value_max_default : v_schema.number_value_max
          number_value_min  = v_schema.number_value_min == null ? var.pool_schema_number_value_min_default : v_schema.number_value_min
          string_length_max = v_schema.string_length_max == null ? var.pool_schema_string_length_max_default : v_schema.string_length_max
          string_length_min = v_schema.string_length_min == null ? var.pool_schema_string_length_min_default : v_schema.string_length_min
        }
      }
    }
  }
  l3_map = {
    for k, v in var.pool_map : k => {
      acm_certificate_arn = local.l2_map[k].dns_from_fqdn == null ? null : var.cdn_global_data.domain_cert_map[local.l2_map[k].dns_from_fqdn].certificate_arn
    }
  }
  lx_map = {
    for k, v in var.pool_map : k => merge(local.l1_map[k], local.l2_map[k], local.l3_map[k])
  }
  output_data = {
    for k, v in local.lx_map : k => merge(
      {
        for k_attr, v_attr in v : k_attr => v_attr
        if !contains([], k_attr)
      },
      {
        dns_alias          = v.dns_from_fqdn == null ? null : module.domain_alias.data[k]
        lambda_permission  = module.lambda_permission[k].data
        user_pool_arn      = aws_cognito_user_pool.this_pool[k].arn
        user_pool_client   = module.pool_client.data[k]
        user_pool_endpoint = aws_cognito_user_pool.this_pool[k].endpoint
        user_pool_fqdn     = v.dns_from_fqdn == null ? aws_cognito_user_pool.this_pool[k].endpoint : v.dns_from_fqdn
      }
    )
  }
}
