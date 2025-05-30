{{ name.map() }}

module "vpc_map" {
  source                  = "../../vpc/id_map"
  vpc_map                 = local.l0_map
  vpc_az_key_list_default = var.vpc_az_key_list_default
  vpc_key_default         = var.vpc_key_default
  # vpc_security_group_key_list_default
  # vpc_segment_key_default
  vpc_data_map = var.vpc_data_map
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
  create_elb_listener_1_list = flatten([
    for k, v in local.lx_map : [
      for k_list, v_list in v.elb_listener_map : merge(v, v_list, {
        k_list = k_list
      })
    ]
  ])
  create_elb_listener_x_map = {
    for v in local.create_elb_listener_1_list : v.k_list => v
  }
  create_elb_target_1_list = flatten([
    for k, v in local.lx_map : [
      for k_targ, v_targ in v.elb_target_map : merge(v, v_targ, {
        k_targ = k_targ
      })
    ]
  ])
  create_elb_target_x_map = {
    for v in local.create_elb_target_1_list : v.k_targ => v
  }
  create_ip_map = {
    for k, v in local.lx_map : k => merge(v, {
    }) if v.create_dns_alias
  }
  create_template_map = {
    for k, v in local.lx_map : k => merge(v, {
      iam_instance_profile_arn = module.instance_role[k].data.iam_instance_profile_arn
      secret_password          = jsondecode(module.password_secret.secret_map[k])["password"]
    })
  }
  l0_map = {
    for k, v in var.instance_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], module.vpc_map.data[k], {
      cert_contact_email            = v.cert_contact_email == null ? var.instance_cert_contact_email_default : v.cert_contact_email
      create_instance               = v.create_instance == null ? var.instance_create_instance_default : v.create_instance
      dns_from_zone_key             = v.dns_from_zone_key == null ? var.instance_dns_from_zone_key_default : v.dns_from_zone_key
      elb_acm_certificate_key_admin = v.elb_acm_certificate_key_admin == null ? var.instance_elb_acm_certificate_key_admin_default : v.elb_acm_certificate_key_admin
      elb_acm_certificate_key_vpn   = v.elb_acm_certificate_key_vpn == null ? var.instance_elb_acm_certificate_key_vpn_default : v.elb_acm_certificate_key_vpn
      elb_api_endpoint_enabled      = v.elb_api_endpoint_enabled == null ? var.instance_elb_api_endpoint_enabled_default : v.elb_api_endpoint_enabled
      elb_key_admin                 = v.elb_key_admin == null ? var.instance_elb_key_admin_default : v.elb_key_admin
      elb_key_vpn                   = v.elb_key_vpn == null ? var.instance_elb_key_vpn_default : v.elb_key_vpn
      elb_rule_priority_admin       = v.elb_rule_priority_admin == null ? var.instance_elb_rule_priority_admin_default : v.elb_rule_priority_admin
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      auto_scaling_num_instances_min = local.l1_map[k].create_instance ? 1 : 0
      behind_elb                     = local.l1_map[k].elb_acm_certificate_key_admin != null && local.l1_map[k].elb_acm_certificate_key_vpn != null && local.l1_map[k].elb_key_admin != null && local.l1_map[k].elb_key_vpn != null
      dns_from_fqdn                  = v.dns_from_fqdn == null ? "vpn.${local.l1_map[k].dns_from_zone_key}" : v.dns_from_fqdn
    }
  }
  l3_map = {
    for k, v in local.l0_map : k => {
      create_dns_alias           = local.l1_map[k].create_instance && local.l1_map[k].dns_from_zone_key != null && !local.l2_map[k].behind_elb
      elb_admin_host_header_name = local.l2_map[k].behind_elb ? var.dns_data.region_domain_cert_map[var.std_map.aws_region_name][local.l1_map[k].elb_acm_certificate_key_admin].name_simple : null
      elb_target_map = local.l2_map[k].behind_elb ? merge(
        {
          "${k}_tcp" = {
            health_check_port     = null
            health_check_protocol = null
            target_port           = 443
            target_protocol       = "TCP"
          }
          "${k}_udp" = {
            health_check_port     = 443 # Health check is mandatory but does not support UDP
            health_check_protocol = null
            target_port           = 1194
            target_protocol       = "UDP"
          }
          "${k}_web" = {
            health_check_port     = null
            health_check_protocol = "HTTPS"
            target_port           = 943
            target_protocol       = "HTTPS"
          }
        },
        local.l1_map[k].elb_api_endpoint_enabled ? {
          "${k}_api" = {
            health_check_port     = null
            health_check_protocol = null
            target_port           = 945
            target_protocol       = "TLS"
          }
        } : {},
      ) : {}
      vpc_security_group_key_list = v.vpc_security_group_key_list == null ? local.l2_map[k].behind_elb ? var.vpc_security_group_key_list_elb_default : var.vpc_security_group_key_list_public_default : v.vpc_security_group_key_list
      vpc_segment_key             = v.vpc_segment_key == null ? local.l2_map[k].behind_elb ? var.vpc_segment_key_elb_default : var.vpc_segment_key_public_default : v.vpc_segment_key
    }
  }
  l4_map = {
    for k, v in local.l0_map : k => {
      elb_listener_map = local.l2_map[k].behind_elb ? merge(
        {
          "${k}_tcp" = {
            acm_certificate_key = local.l1_map[k].elb_acm_certificate_key_vpn
            elb_key             = local.l1_map[k].elb_key_vpn
            listen_port         = null
            listen_protocol     = "TCP"
            rule_condition_map  = {}
            rule_priority       = null
          }
          "${k}_udp" = {
            acm_certificate_key = null
            elb_key             = local.l1_map[k].elb_key_vpn
            listen_port         = 1194
            listen_protocol     = "UDP"
            rule_condition_map  = {}
            rule_priority       = null
          }
          "${k}_web" = {
            acm_certificate_key = local.l1_map[k].elb_acm_certificate_key_admin
            elb_key             = local.l1_map[k].elb_key_admin
            listen_port         = null
            listen_protocol     = null
            rule_condition_map = {
              host_match = {
                host_header_pattern_list = [local.l3_map[k].elb_admin_host_header_name]
              }
            }
            rule_priority = local.l1_map[k].elb_rule_priority_admin
          }
        },
        local.l1_map[k].elb_api_endpoint_enabled ? {
          "${k}_api" = {
            acm_certificate_key = local.l1_map[k].elb_acm_certificate_key_vpn
            elb_key             = local.l1_map[k].elb_key_vpn
            listen_port         = 945
            listen_protocol     = "TLS"
            rule_condition_map  = {}
            rule_priority       = null
          }
        } : {},
      ) : {}
      elb_target_group_key_list = local.l2_map[k].behind_elb ? keys(local.l3_map[k].elb_target_map) : []
    }
  }
  lx_map = {
    for k, v in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k], local.l3_map[k], local.l4_map[k])
  }
  output_data = {
    for k, v in local.lx_map : k => merge(
      {
        for k_attr, v_attr in v : k_attr => v_attr if !contains([], k_attr)
      },
      {
        auto_scaling_group = module.asg.data[k]
        elastic_ip         = v.create_dns_alias ? module.elastic_ip.data[k] : null
        elb_listener = {
          for k_list, _ in v.elb_listener_map : k_list => module.listener.data[k_list]
        }
        elb_target = {
          for k_targ, _ in v.elb_target_map : k_targ => module.target_group.data[k_targ]
        }
        dns_alias         = v.create_dns_alias ? module.dns_alias.data[k] : null
        instance_template = module.instance_template.data[k]
        license_secret    = module.license_secret.data[k]
        password_secret   = module.password_secret.data[k]
        role              = module.instance_role[k].data
      }
    )
  }
}
