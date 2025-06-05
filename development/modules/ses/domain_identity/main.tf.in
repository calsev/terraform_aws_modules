resource "aws_sesv2_email_identity" "this_domain" {
  for_each               = local.lx_map
  configuration_set_name = each.value.configuration_set_name
  email_identity         = each.value.name_simple
  dkim_signing_attributes {
    next_signing_key_length = each.value.dkim_signing_key_length
  }
  tags = each.value.tags
}

resource "aws_sesv2_email_identity_feedback_attributes" "forwarding" {
  for_each                 = local.lx_map
  email_identity           = aws_sesv2_email_identity.this_domain[each.key].email_identity
  email_forwarding_enabled = each.value.email_forwarding_enabled
}

resource "aws_sesv2_email_identity_mail_from_attributes" "mail_from" {
  for_each               = local.lx_map
  behavior_on_mx_failure = each.value.fallback_to_ses_send_domain ? "USE_DEFAULT_VALUE" : "REJECT_MESSAGE"
  email_identity         = aws_sesv2_email_identity.this_domain[each.key].email_identity
  mail_from_domain       = each.value.mail_from_fqdn
}

module "dns_mx" {
  source                           = "../../dns/record"
  dns_data                         = var.dns_data
  record_dns_from_zone_key_default = var.domain_dns_from_zone_key_default
  record_dns_type_default          = "MX"
  record_map                       = local.create_dns_mx_map
  std_map                          = var.std_map
}

module "dns_txt" {
  source                           = "../../dns/record"
  dns_data                         = var.dns_data
  record_dns_from_zone_key_default = var.domain_dns_from_zone_key_default
  record_dns_type_default          = "TXT"
  record_map                       = local.create_dns_txt_map
  std_map                          = var.std_map
}

module "dns_dkim" {
  source                           = "../../dns/record"
  dns_data                         = var.dns_data
  record_dns_from_zone_key_default = var.domain_dns_from_zone_key_default
  record_dns_type_default          = "CNAME"
  record_map                       = local.create_dns_dkim_map
  std_map                          = var.std_map
}

module "dns_dmarc" {
  source                           = "../../dns/record"
  dns_data                         = var.dns_data
  record_dns_from_zone_key_default = var.domain_dns_from_zone_key_default
  record_dns_type_default          = "TXT"
  record_map                       = local.create_dns_dmarc_map
  std_map                          = var.std_map
}
