module "name_map" {
  source                          = "../../name_map"
  name_include_app_fields_default = var.instance_name_include_app_fields_default
  name_infix_default              = var.instance_name_infix_default
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
    }) if v.dns_from_zone_key != null
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
      dns_from_zone_key = v.dns_from_zone_key == null ? var.instance_dns_from_zone_key_default : v.dns_from_zone_key
      k_license_secret  = "${k}_open_vpn_license"
      k_password_secret = "${k}_open_vpn_admin_password"
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
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
        auto_scaling_group = module.asg.data[k]
        elastic_ip         = module.elastic_ip.data[k]
        dns_alias          = v.dns_from_zone_key == null ? null : module.dns_alias.data[k]
        instance_template  = module.instance_template.data[k]
        license_secret     = module.license_secret.data[v.k_license_secret]
        password_secret    = module.password_secret.data[v.k_password_secret]
        role               = module.instance_template.data[k]
      }
    )
  }
}
