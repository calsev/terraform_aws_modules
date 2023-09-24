resource "aws_sesv2_email_identity" "this_domain" {
  for_each               = local.domain_map
  configuration_set_name = each.value.configuration_set_name
  email_identity         = each.value.name_simple
  tags                   = each.value.tags
}

resource "aws_sesv2_email_identity_feedback_attributes" "forwarding" {
  for_each                 = local.domain_map
  email_identity           = aws_sesv2_email_identity.this_domain[each.key].email_identity
  email_forwarding_enabled = each.value.email_forwarding_enabled
}
