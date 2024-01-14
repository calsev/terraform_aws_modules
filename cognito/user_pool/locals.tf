module "name_map" {
  source   = "../../name_map"
  name_map = var.pool_map
  std_map  = var.std_map
}

locals {
  client_map = {
    for k_pool, v_pool in local.lx_map : k_pool => merge(v_pool, {
      user_pool_id = aws_cognito_user_pool.this_pool[k_pool].id
    })
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
      invite_email_message_template                     = v.invite_email_message_template == null ? var.pool_invite_email_message_template_default : v.invite_email_message_template
      invite_email_subject                              = v.invite_email_subject == null ? var.pool_invite_email_subject_default : v.invite_email_subject
      invite_sms_message_template                       = v.invite_sms_message_template == null ? var.pool_invite_sms_message_template_default : v.invite_sms_message_template
      only_admin_create_user                            = v.only_admin_create_user == null ? var.pool_only_admin_create_user_default : v.only_admin_create_user
      password_minimum_length                           = v.password_minimum_length == null ? var.pool_password_minimum_length_default : v.password_minimum_length
      password_require_lowercase                        = v.password_require_lowercase == null ? var.pool_password_require_lowercase_default : v.password_require_lowercase
      password_require_numbers                          = v.password_require_numbers == null ? var.pool_password_require_numbers_default : v.password_require_numbers
      password_require_symbols                          = v.password_require_symbols == null ? var.pool_password_require_symbols_default : v.password_require_symbols
      password_require_uppercase                        = v.password_require_uppercase == null ? var.pool_password_require_uppercase_default : v.password_require_uppercase
      password_temporary_validity_days                  = v.password_temporary_validity_days == null ? var.pool_password_temporary_validity_days_default : v.password_temporary_validity_days
      username_alias_attribute_list                     = v.username_alias_attribute_list == null ? var.pool_username_alias_attribute_list_default : v.username_alias_attribute_list
      username_attribute_list                           = v.username_attribute_list == null ? var.pool_username_attribute_list_default : v.username_attribute_list
      username_case_sensitive                           = v.username_case_sensitive == null ? var.pool_username_case_sensitive_default : v.username_case_sensitive
      verify_confirm_with_link                          = v.verify_confirm_with_link == null ? var.pool_verify_confirm_with_link_default : v.verify_confirm_with_link
      verify_email_message_by_code_template             = v.verify_email_message_by_code_template == null ? var.pool_verify_email_message_by_code_template_default : v.verify_email_message_by_code_template
      verify_email_message_by_link_template             = v.verify_email_message_by_link_template == null ? var.pool_verify_email_message_by_link_template_default : v.verify_email_message_by_link_template
      verify_email_message_by_code_subject              = v.verify_email_message_by_code_subject == null ? var.pool_verify_email_message_by_code_subject_default : v.verify_email_message_by_code_subject
      verify_email_message_by_link_subject              = v.verify_email_message_by_link_subject == null ? var.pool_verify_email_message_by_link_subject_default : v.verify_email_message_by_link_subject
      verify_sms_message_template                       = v.verify_sms_message_template == null ? var.pool_verify_sms_message_template_default : v.verify_sms_message_template
      dns_domain                                        = v.dns_domain == null ? var.pool_dns_domain_default : v.dns_domain
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
      dns_fqdn    = "${local.l1_map[k].dns_subdomain}.${local.l1_map[k].dns_domain}"
      dns_zone_id = var.dns_data.domain_to_dns_zone_map[local.l1_map[k].dns_domain].dns_zone_id
    }
  }
  l3_map = {
    for k, v in var.pool_map : k => {
      acm_certificate_arn = var.cdn_global_data.domain_cert_map[local.l2_map[k].dns_fqdn].arn
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
      module.pool_client.data[k],
      {
        user_pool_arn      = aws_cognito_user_pool.this_pool[k].arn
        user_pool_endpoint = aws_cognito_user_pool.this_pool[k].endpoint
      }
    )
  }
}
