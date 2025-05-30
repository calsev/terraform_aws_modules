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
  l0_map = {
    for k, v in var.sms_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      enabled                 = v.enabled == null ? var.sms_enabled_default : v.enabled
      pinpoint_application_id = v.pinpoint_application_id == null ? var.sms_pinpoint_application_id_default : v.pinpoint_application_id
      provider_short_code     = v.provider_short_code == null ? var.sms_provider_short_code_default : v.provider_short_code
      sender_id_string        = v.sender_id_string == null ? var.sms_sender_id_string_default : v.sender_id_string
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
    }
  }
  lx_map = {
    for k, _ in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k])
  }
  output_data = {
    for k, v in local.lx_map : k => merge(
      {
        for k_attr, v_attr in v : k_attr => v_attr if !contains([], k_attr)
      },
      {
        promotional_messages_per_second   = aws_pinpoint_sms_channel.sms[k].promotional_messages_per_second
        transactional_messages_per_second = aws_pinpoint_sms_channel.sms[k].transactional_messages_per_second
      },
    )
  }
}
