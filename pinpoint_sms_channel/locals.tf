module "name_map" {
  source   = "../name_map"
  name_map = var.sms_map
  std_map  = var.std_map
}

locals {
  sms_map = {
    for k, _ in var.sms_map : k => merge(local.l1_map[k], local.l2_map[k])
  }
  l1_map = {
    for k, v in var.sms_map : k => merge(v, module.name_map.data[k], {
      enabled                 = v.enabled == null ? var.sms_enabled_default : v.enabled
      pinpoint_application_id = v.pinpoint_application_id == null ? var.sms_pinpoint_application_id_default : v.pinpoint_application_id
      provider_short_code     = v.provider_short_code == null ? var.sms_provider_short_code_default : v.provider_short_code
      sender_id_string        = v.sender_id_string == null ? var.sms_sender_id_string_default : v.sender_id_string
    })
  }
  l2_map = {
    for k, v in var.sms_map : k => {
    }
  }
  output_data = {
    for k, v in local.sms_map : k => merge(
      v,
      {
        promotional_messages_per_second   = aws_pinpoint_sms_channel.sms[k].promotional_messages_per_second
        transactional_messages_per_second = aws_pinpoint_sms_channel.sms[k].transactional_messages_per_second
      },
    )
  }
}
