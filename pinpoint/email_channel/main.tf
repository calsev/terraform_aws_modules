resource "aws_pinpoint_email_channel" "email" {
  for_each          = local.email_map
  application_id    = each.value.pinpoint_application_id
  configuration_set = each.value.ses_configuration_set_name # This is not the ARN, despite TF docs
  enabled           = each.value.enabled
  from_address      = each.value.from_address
  identity          = each.value.ses_identity_arn
  role_arn          = each.value.iam_role_arn
}
