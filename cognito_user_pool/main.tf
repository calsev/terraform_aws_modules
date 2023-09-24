resource "aws_cognito_user_pool" "this_pool" {
  for_each = local.pool_map
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
  # email_configuration # TODO
  email_verification_message = null # Conflicts with verification_message_template
  email_verification_subject = null # Conflicts with verification_message_template
  # lambda_config # TODO
  # mfa_configuration # TODO
  name = each.value.name_effective
  password_policy {
    minimum_length                   = each.value.password_minimum_length
    require_lowercase                = each.value.password_require_lowercase
    require_numbers                  = each.value.password_require_numbers
    require_symbols                  = each.value.password_require_symbols
    require_uppercase                = each.value.password_require_uppercase
    temporary_password_validity_days = each.value.password_temporary_validity_days
  }
  # schema # TODO
  sms_authentication_message = null # TODO
  # sms_configuration # TODO
  sms_verification_message = null # Conflicts with verification_message_template
  # software_token_mfa_configuration # TODO
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

resource "aws_cognito_user_pool_domain" "domain" {
  for_each        = local.pool_map
  certificate_arn = each.value.acm_certificate_arn
  domain          = each.value.dns_fqdn
  user_pool_id    = aws_cognito_user_pool.this_pool[each.key].id
}

resource "aws_route53_record" "domain_alias" {
  for_each = local.pool_map
  alias {
    evaluate_target_health = false
    name                   = aws_cognito_user_pool_domain.domain[each.key].cloudfront_distribution
    zone_id                = aws_cognito_user_pool_domain.domain[each.key].cloudfront_distribution_zone_id
  }
  name    = aws_cognito_user_pool_domain.domain[each.key].domain
  type    = "A"
  zone_id = each.value.dns_zone_id
}
