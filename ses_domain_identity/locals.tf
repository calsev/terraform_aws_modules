module "name_map" {
  source                = "../name_map"
  name_map              = var.domain_map
  std_map               = var.std_map
  name_regex_allow_list = ["."]
}

locals {
  dkim_flattened_list = flatten([
    for k, v in local.domain_map : [
      for index in range(3) : merge(v, {
        k     = k
        index = index
      })
    ]
  ])
  dkim_flattened_map = {
    for v in local.dkim_flattened_list : "${v.k}-${v.index}" => v
  }
  l1_map = {
    for k, v in var.domain_map : k => merge(v, module.name_map.data[k], {
      configuration_set_key       = v.configuration_set_key == null ? var.domain_configuration_set_key_default : v.configuration_set_key
      dkim_signing_key_length     = v.dkim_signing_key_length == null ? var.domain_dkim_signing_key_length_default : v.dkim_signing_key_length
      email_forwarding_enabled    = v.email_forwarding_enabled == null ? var.domain_email_forwarding_enabled_default : v.email_forwarding_enabled
      fallback_to_ses_send_domain = v.fallback_to_ses_send_domain == null ? var.domain_fallback_to_ses_send_domain_default : v.fallback_to_ses_send_domain
      domain_name                 = v.domain_name == null ? var.domain_name_default : v.domain_name
      mail_from_subdomain         = v.mail_from_subdomain == null ? var.domain_mail_from_subdomain_default : v.mail_from_subdomain
    })
  }
  l2_map = {
    for k, v in var.domain_map : k => {
      configuration_set_name = local.l1_map[k].configuration_set_key == null ? null : var.config_data_map[local.l1_map[k].configuration_set_key].configuration_set_name
      dns_zone_id            = var.dns_data.domain_to_dns_zone_map[local.l1_map[k].domain_name].dns_zone_id
      mail_from_fqdn         = "${local.l1_map[k].mail_from_subdomain}.${local.l1_map[k].name_simple}"
    }
  }
  output_data = {
    for k, v in var.domain_map : k => merge(
      {
        for k_attr, v_attr in local.domain_map[k] : k_attr => v_attr if !contains([], k_attr)
      },
      {
        identity_arn     = aws_sesv2_email_identity.this_domain[k].arn
        mail_from_domain = aws_sesv2_email_identity_mail_from_attributes.mail_from[k].mail_from_domain
        mail_from_id     = aws_sesv2_email_identity_mail_from_attributes.mail_from[k].id
      },
    )
  }
  domain_map = {
    for k, v in var.domain_map : k => merge(local.l1_map[k], local.l2_map[k])
  }
}
