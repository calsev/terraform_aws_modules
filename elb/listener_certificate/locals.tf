module "name_map" {
  source                          = "../../name_map"
  name_include_app_fields_default = var.listener_name_include_app_fields_default
  name_infix_default              = var.listener_name_infix_default
  name_map                        = local.l0_map
  std_map                         = var.std_map
}

locals {
  create_cert_map = {
    for k, v in local.lx_map : k => v if v.create_cert
  }
  create_dns_1_map = {
    for k, v in local.lx_map : k => merge(v, {
      dns_alias_name    = v.elb_dns_name
      dns_alias_zone_id = v.elb_dns_zone_id
      dns_from_fqdn     = v.acm_certificate_fqdn
    }) if local.l1_map[k].acm_certificate_fqdn != null
  }
  create_dns_2_map = {
    # This exists to ensure one record per name as there may be multiple listeners
    for k, v in local.create_dns_1_map : v.acm_certificate_fqdn => v...
  }
  create_dns_x_map = {
    for fqdn, v in local.create_dns_2_map : fqdn => v[0]
  }
  l0_map = {
    for k, v in var.listener_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], var.elb_data_map[v.elb_key], {
      acm_certificate_fqdn = v.acm_certificate_fqdn == null ? var.listener_acm_certificate_fqdn_default : v.acm_certificate_fqdn
      elb_listener_arn     = v.elb_listener_arn == null ? var.listener_elb_listener_arn_default : v.elb_listener_arn
      is_listener          = v.is_listener == null ? var.listener_is_listener_default : v.is_listener
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      acm_certificate_arn = local.l1_map[k].acm_certificate_fqdn == null ? null : var.dns_data.region_domain_cert_map[var.std_map.aws_region_name][local.l1_map[k].acm_certificate_fqdn].certificate_arn
      create_cert         = local.l1_map[k].acm_certificate_fqdn != null && !local.l1_map[k].is_listener # listeners have default certs, these are for rules
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
        dns = v.acm_certificate_fqdn == null ? null : module.dns_alias.data[v.acm_certificate_fqdn]
      }
    )
  }
}
