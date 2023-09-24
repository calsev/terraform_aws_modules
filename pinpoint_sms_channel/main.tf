resource "aws_pinpoint_sms_channel" "sms" {
  for_each       = local.sms_map
  application_id = each.value.pinpoint_application_id
  enabled        = each.value.enabled
  sender_id      = each.value.sender_id_string
  short_code     = each.value.provider_short_code
}
