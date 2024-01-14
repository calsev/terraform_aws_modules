resource "aws_pinpoint_app" "this_app" {
  for_each = local.app_map
  campaign_hook {
    lambda_function_name = each.value.campaign_hook_lambda_function_arn
    mode                 = each.value.campaign_hook_mode
    web_url              = each.value.campaign_hook_web_url
  }
  limits {
    daily               = each.value.limit_messages_daily
    maximum_duration    = each.value.limit_maximum_duration_min == null ? null : each.value.limit_maximum_duration_min * 60
    messages_per_second = each.value.limit_messages_per_second
    total               = each.value.limit_messages_total
  }
  name = each.value.name_effective
  quiet_time {
    end   = each.value.quiet_time_end_local
    start = each.value.quiet_time_start_local
  }
  tags = each.value.tags
}

module "email_channel" {
  source                                  = "../../pinpoint/email_channel"
  comms_data                              = var.comms_data
  email_map                               = local.email_flattened_map
  email_comms_ses_domain_key_default      = var.app_email_comms_ses_domain_key_default
  email_enabled_default                   = var.app_email_channel_enabled_default
  email_iam_role_arn_custom_default       = var.app_email_channel_iam_role_arn_custom_default
  email_ses_configuration_set_key_default = var.app_email_channel_ses_configuration_set_key_default
  email_ses_identity_arn_custom_default   = var.app_email_channel_ses_identity_arn_custom_default
  std_map                                 = var.std_map
}

module "sms_channel" {
  source                          = "../../pinpoint/sms_channel"
  sms_map                         = local.sms_flattened_map
  sms_enabled_default             = var.app_sms_channel_enabled_default
  sms_sender_id_string_default    = var.app_sms_channel_sender_id_string_default
  sms_provider_short_code_default = var.app_sms_channel_provider_short_code_default
  std_map                         = var.std_map
}
