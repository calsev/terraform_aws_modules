module "name_map" {
  source                          = "../../name_map"
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_map                        = local.l0_map
  std_map                         = var.std_map
}

locals {
  create_asg_map = {
    for k, v in local.lx_map : k => merge(v, {
      launch_template_id = module.instance_template.data[k].launch_template_id
    })
  }
  create_dns_alias_map = {
    for k, v in local.lx_map : k => merge(v, {
      dns_record_list = [module.elastic_ip.data[k].eip_public_ip]
    }) if v.create_dns_alias
  }
  create_ip_map = {
    for k, v in local.lx_map : k => merge(v, {
    }) if v.create_dns_alias
  }
  create_open_vpn_license_map = {
    for k, v in local.lx_map : v.k_license_secret => merge(v, {
    })
  }
  create_open_vpn_password_map = {
    for k, v in local.lx_map : v.k_password_secret => merge(v, {
    })
  }
  create_template_map = {
    for k, v in local.lx_map : k => merge(v, {
      iam_instance_profile_arn = module.instance_role[k].data.iam_instance_profile_arn
    })
  }
  l0_map = {
    for k, v in var.instance_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      cert_contact_email = v.cert_contact_email == null ? var.instance_cert_contact_email_default : v.cert_contact_email
      create_instance    = v.create_instance == null ? var.instance_create_instance_default : v.create_instance
      dns_from_zone_key  = v.dns_from_zone_key == null ? var.instance_dns_from_zone_key_default : v.dns_from_zone_key
      k_license_secret   = "${k}_open_vpn_license"
      k_password_secret  = "${k}_open_vpn_admin_password"
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      auto_scaling_num_instances_min = local.l1_map[k].create_instance ? 1 : 0
      create_dns_alias               = local.l1_map[k].create_instance && local.l1_map[k].dns_from_zone_key != null
      dns_from_fqdn                  = v.dns_from_fqdn == null ? "vpn.${local.l1_map[k].dns_from_zone_key}" : v.dns_from_fqdn
    }
  }
  l3_map = {
    for k, v in local.l0_map : k => {
    }
  }
  lx_map = {
    for k, v in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k], local.l3_map[k])
  }
  output_data = {
    for k, v in local.lx_map : k => merge(
      {
        for k_attr, v_attr in v : k_attr => v_attr if !contains([], k_attr)
      },
      {
        auto_scaling_group = module.asg.data[k]
        elastic_ip         = v.create_dns_alias ? module.elastic_ip.data[k] : null
        dns_alias          = v.create_dns_alias ? module.dns_alias.data[k] : null
        instance_template  = module.instance_template.data[k]
        license_secret     = module.license_secret.data[v.k_license_secret]
        password_secret    = module.password_secret.data[v.k_password_secret]
        role               = module.instance_role[k].data
      }
    )
  }
}
