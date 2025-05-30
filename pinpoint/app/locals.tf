module "name_map" {
  source                          = "../../name_map"
  name_append_default             = var.name_append_default
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_map                        = local.l0_map
  name_prefix_default             = var.name_prefix_default
  name_prepend_default            = var.name_prepend_default
  name_regex_allow_list           = var.name_regex_allow_list
  name_suffix_default             = var.name_suffix_default
  std_map                         = var.std_map
}

locals {
  create_email_1_list = flatten([
    for k, v in local.lx_map : [
      for k_email, v_email in v.email_channel_map : merge(v_email, {
        k_app_email             = "${k}_${k_email}"
        pinpoint_application_id = aws_pinpoint_app.this_app[k].application_id
      })
    ]
  ])
  create_email_x_map = {
    for v in local.create_email_1_list : v.k_app_email => v
  }
  create_sms_1_list = flatten([
    for k, v in local.lx_map : [
      for k_sms, v_sms in v.sms_channel_map : merge(v_sms, {
        k_app_sms               = "${k}_${k_sms}"
        pinpoint_application_id = aws_pinpoint_app.this_app[k].application_id
      })
    ]
  ])
  create_sms_x_map = {
    for v in local.create_sms_1_list : v.k_app_sms => v
  }
  l0_map = {
    for k, v in var.app_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      campaign_hook_lambda_function_arn = v.campaign_hook_lambda_function_arn == null ? var.app_campaign_hook_lambda_function_arn_default : v.campaign_hook_lambda_function_arn
      campaign_hook_web_url             = v.campaign_hook_web_url == null ? var.app_campaign_hook_web_url_default : v.campaign_hook_web_url
      email_channel_map                 = v.email_channel_map == null ? {} : v.email_channel_map
      limit_messages_daily              = v.limit_messages_daily == null ? var.app_limit_messages_daily_default : v.limit_messages_daily
      limit_messages_per_second         = v.limit_messages_per_second == null ? var.app_limit_messages_per_second_default : v.limit_messages_per_second
      limit_messages_total              = v.limit_messages_total == null ? var.app_limit_messages_total_default : v.limit_messages_total
      limit_maximum_duration_min        = v.limit_maximum_duration_min == null ? var.app_limit_maximum_duration_min_default : v.limit_maximum_duration_min
      quiet_time_end_local              = v.quiet_time_end_local == null ? var.app_quiet_time_end_local_default : v.quiet_time_end_local
      quiet_time_start_local            = v.quiet_time_start_local == null ? var.app_quiet_time_start_local_default : v.quiet_time_start_local
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      campaign_hook_valid = local.l1_map[k].campaign_hook_lambda_function_arn != null || local.l1_map[k].campaign_hook_web_url != null
    }
  }
  l3_map = {
    for k, v in local.l0_map : k => {
      campaign_hook_mode = local.l2_map[k].campaign_hook_valid ? v.campaign_hook_mode == null ? var.app_campaign_hook_mode_default : v.campaign_hook_mode : null
    }
  }
  lx_map = {
    for k, _ in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k], local.l3_map[k])
  }
  output_data = {
    for k, v in local.lx_map : k => merge(
      {
        for k_attr, v_attr in v : k_attr => v_attr if !contains([], k_attr)
      },
      {
        application_id = aws_pinpoint_app.this_app[k].application_id
        arn            = aws_pinpoint_app.this_app[k].arn
        email_channel_map = {
          for k_email, _ in v.email_channel_map : k_email => module.email_channel.data["${k}_${k_email}"]
        }
        sms_channel_map = {
          for k_sms, _ in v.sms_channel_map : k_sms => module.sms_channel.data["${k}_${k_sms}"]
        }
      },
    )
  }
}
