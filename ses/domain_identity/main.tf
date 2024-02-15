resource "aws_sesv2_email_identity" "this_domain" {
  for_each               = local.domain_map
  configuration_set_name = each.value.configuration_set_name
  email_identity         = each.value.name_simple
  dkim_signing_attributes {
    next_signing_key_length = each.value.dkim_signing_key_length
  }
  tags = each.value.tags
}

resource "aws_sesv2_email_identity_feedback_attributes" "forwarding" {
  for_each                 = local.domain_map
  email_identity           = aws_sesv2_email_identity.this_domain[each.key].email_identity
  email_forwarding_enabled = each.value.email_forwarding_enabled
}

resource "aws_sesv2_email_identity_mail_from_attributes" "mail_from" {
  for_each               = local.domain_map
  behavior_on_mx_failure = each.value.fallback_to_ses_send_domain ? "USE_DEFAULT_VALUE" : "REJECT_MESSAGE"
  email_identity         = aws_sesv2_email_identity.this_domain[each.key].email_identity
  mail_from_domain       = each.value.mail_from_fqdn
}

resource "aws_route53_record" "mail_from_mx" {
  # See AWs console for verified identities > "Custom MAIL FROM domain" > "Publish DNS records"
  for_each = local.domain_map
  name     = aws_sesv2_email_identity_mail_from_attributes.mail_from[each.key].mail_from_domain
  records  = ["10 feedback-smtp.${var.std_map.aws_region_name}.amazonses.com"]
  ttl      = var.dns_data.ttl_map.mx
  type     = "MX"
  zone_id  = each.value.dns_zone_id
}

resource "aws_route53_record" "mail_from_txt" {
  # See AWs console for verified identities > "Custom MAIL FROM domain" > "Publish DNS records"
  for_each = local.domain_map
  name     = aws_sesv2_email_identity_mail_from_attributes.mail_from[each.key].mail_from_domain
  records  = ["v=spf1 include:amazonses.com -all"]
  ttl      = var.dns_data.ttl_map.mx
  type     = "TXT"
  zone_id  = each.value.dns_zone_id
}

resource "aws_route53_record" "dkim_record" {
  # See AWs console for verified identities > "DomainKeys Identified Mail (DKIM)" > "Publish DNS records"
  for_each = local.dkim_flattened_map
  name     = "${aws_sesv2_email_identity.this_domain[each.value.k].dkim_signing_attributes[0].tokens[each.value.index]}._domainkey"
  records  = ["${aws_sesv2_email_identity.this_domain[each.value.k].dkim_signing_attributes[0].tokens[each.value.index]}.dkim.amazonses.com"]
  type     = "CNAME"
  ttl      = var.dns_data.ttl_map.cname
  zone_id  = each.value.dns_zone_id
}
