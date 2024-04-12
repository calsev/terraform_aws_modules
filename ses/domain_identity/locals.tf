module "name_map" {
  source                = "../../name_map"
  name_map              = local.l0_map
  name_regex_allow_list = ["."]
  std_map               = var.std_map
}

locals {
  create_dns_dkim_list = flatten([
    for k, v in local.lx_map : [
      for index in range(3) : merge(v, {
        # See AWs console for verified identities > "DomainKeys Identified Mail (DKIM)" > "Publish DNS records"
        dns_from_fqdn   = "${aws_sesv2_email_identity.this_domain[k].dkim_signing_attributes[0].tokens[index]}._domainkey"
        dns_record_list = ["${aws_sesv2_email_identity.this_domain[k].dkim_signing_attributes[0].tokens[index]}.dkim.amazonses.com"]
        k               = k
        index           = index
      })
    ]
  ])
  create_dns_dkim_map = {
    for v in local.create_dns_dkim_list : "${v.k}_${v.index}" => v
  }
  create_dns_dmarc_map = {
    for k, v in local.lx_map : k => merge(v, {
      # See AWs console for verified identities > DMARC > "Publish DNS records"
      dns_from_fqdn   = "_dmarc.${v.name_simple}"
      dns_record_list = ["v=DMARC1; p=none;"]
    })
  }
  create_dns_mx_map = {
    for k, v in local.lx_map : k => merge(v, {
      # See AWs console for verified identities > "Custom MAIL FROM domain" > "Publish DNS records"
      dns_from_fqdn   = aws_sesv2_email_identity_mail_from_attributes.mail_from[k].mail_from_domain
      dns_record_list = ["10 feedback-smtp.${var.std_map.aws_region_name}.amazonses.com"]
    })
  }
  create_dns_txt_map = {
    for k, v in local.lx_map : k => merge(v, {
      # See AWs console for verified identities > "Custom MAIL FROM domain" > "Publish DNS records"
      dns_from_fqdn   = aws_sesv2_email_identity_mail_from_attributes.mail_from[k].mail_from_domain
      dns_record_list = ["v=spf1 include:amazonses.com -all"]
    })
  }
  l0_map = {
    for k, v in var.domain_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      configuration_set_key       = v.configuration_set_key == null ? var.domain_configuration_set_key_default : v.configuration_set_key
      dkim_signing_key_length     = v.dkim_signing_key_length == null ? var.domain_dkim_signing_key_length_default : v.dkim_signing_key_length
      email_forwarding_enabled    = v.email_forwarding_enabled == null ? var.domain_email_forwarding_enabled_default : v.email_forwarding_enabled
      fallback_to_ses_send_domain = v.fallback_to_ses_send_domain == null ? var.domain_fallback_to_ses_send_domain_default : v.fallback_to_ses_send_domain
      mail_from_subdomain         = v.mail_from_subdomain == null ? var.domain_mail_from_subdomain_default : v.mail_from_subdomain
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      configuration_set_name = local.l1_map[k].configuration_set_key == null ? null : var.config_data_map[local.l1_map[k].configuration_set_key].configuration_set_name
      mail_from_fqdn         = "${local.l1_map[k].mail_from_subdomain}.${local.l1_map[k].name_simple}"
    }
  }
  lx_map = {
    for k, v in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k])
  }
  output_data = {
    for k, v in local.lx_map : k => merge(
      {
        for k_attr, v_attr in v : k_attr => v_attr if !contains([], k_attr)
      },
      {
        dns_dkim = [
          for index in range(3) : module.dns_dkim.data["${k}_${index}"]
        ]
        dns_dmarc        = module.dns_dmarc.data[k]
        dns_mx           = module.dns_mx.data[k]
        dns_txt          = module.dns_txt.data[k]
        identity_arn     = aws_sesv2_email_identity.this_domain[k].arn
        mail_from_domain = aws_sesv2_email_identity_mail_from_attributes.mail_from[k].mail_from_domain
        mail_from_id     = aws_sesv2_email_identity_mail_from_attributes.mail_from[k].id
      }
    )
  }
}
