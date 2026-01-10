module "name_map" {
  source                          = "../../name_map"
  name_append_default             = var.name_append_default
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_map                        = local.l0_map
  name_prefix_default             = var.name_prefix_default
  name_prepend_default            = var.name_prepend_default
  name_regex_allow_list           = var.name_regex_allow_list
  name_suffix_default             = var.name_suffix_default
  std_map                         = var.std_map
}

locals {
  l0_list = flatten([
    for k, v in var.vpc_map : [
      for k_end, v_end in v.endpoint_map == null ? merge(var.endpoint_map_standard_default, var.endpoint_map_custom_default) : v.endpoint_map : merge(v, v_end, {
        k_end     = replace(k_end, "-", "_")
        k_vpc_end = replace("${k}_${k_end}", "-", "_")
      })
    ]
  ])
  l0_map = {
    for v in local.l0_list : v.k_vpc_end => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      add_region_name             = v.add_region_name == null ? var.endpoint_add_region_name_default : v.add_region_name
      auto_accept_enabled         = v.auto_accept_enabled == null ? var.endpoint_auto_accept_enabled_default : v.auto_accept_enabled
      endpoint_segment_key        = v.endpoint_segment_key == null ? var.endpoint_segment_key_default == null ? v.non_public_segment_list[0] : var.endpoint_segment_key_default : v.endpoint_segment_key
      endpoint_type               = v.endpoint_type == null ? var.endpoint_type_default : v.endpoint_type
      iam_policy_json             = v.iam_policy_json == null ? var.endpoint_iam_policy_json_default : v.iam_policy_json
      ip_address_type             = v.ip_address_type == null ? var.endpoint_ip_address_type_default == null ? v.vpc_assign_ipv6_cidr ? "dualstack" : "ipv4" : var.endpoint_ip_address_type_default : v.ip_address_type
      private_dns_enabled         = v.private_dns_enabled == null ? var.endpoint_private_dns_enabled_default : v.private_dns_enabled
      service_name_override       = v.service_name_override == null ? var.endpoint_service_name_override_default : v.service_name_override
      service_name_short          = replace(v.service_name_short == null ? var.endpoint_service_name_short_default == null ? v.k_end : var.endpoint_service_name_short_default : v.service_name_short, "_", "-")
      vpc_security_group_key_list = v.vpc_security_group_key_list == null ? var.endpoint_vpc_security_group_key_list_default : v.vpc_security_group_key_list
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      dns_record_ip_type = v.dns_record_ip_type == null ? var.endpoint_dns_record_ip_type_default == null ? local.l1_map[k].ip_address_type : var.endpoint_dns_record_ip_type_default : v.dns_record_ip_type
      endpoint_subnet_map = {
        for k_az, v_az in v.endpoint_subnet_map : k_az => merge(v_az, {
          vpc_subnet_id = v.segment_map[local.l1_map[k].endpoint_segment_key].subnet_map[k_az].subnet_id
        })
      }
      iam_policy_doc                                 = local.l1_map[k].iam_policy_json == null ? null : jsondecode(local.l1_map[k].iam_policy_json)
      private_dns_for_inbound_resolver_endpoint_only = local.l1_map[k].private_dns_enabled ? v.private_dns_for_inbound_resolver_endpoint_only == null ? var.endpoint_private_dns_for_inbound_resolver_endpoint_only_default : v.private_dns_for_inbound_resolver_endpoint_only : null
      service_name                                   = local.l1_map[k].service_name_override == null ? "com.amazonaws${local.l1_map[k].add_region_name ? ".${var.std_map.aws_region_name}" : ""}.${local.l1_map[k].service_name_short}" : local.l1_map[k].service_name_override
      vpc_az_key_list                                = length(v.endpoint_subnet_map) == 0 ? v.vpc_availability_zone_letter_list : [for k_az, _ in v.endpoint_subnet_map : k_az]
      vpc_security_group_id_list                     = [for k_sg in local.l1_map[k].vpc_security_group_key_list : v.security_group_id_map[k_sg]]
    }
  }
  l3_map = {
    for k, v in local.l0_map : k => {
      vpc_route_table_id_list = local.l1_map[k].endpoint_type == "Interface" ? [] : flatten([for k_seg, v_seg in v.segment_map : [for k_az, v_az in v_seg.subnet_map : v_az.route_table_id]])
      vpc_subnet_id_eni_list  = [for _, v_az in v.segment_map[local.l1_map[k].endpoint_segment_key].subnet_map : v_az.subnet_id]
    }
  }
  l4_map = {
    for k, v in local.l0_map : k => {
    }
  }
  lx_map = {
    for k, _ in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k], local.l3_map[k], local.l4_map[k])
  }
  output_data = {
    for k, v in var.vpc_map : k => merge(v, {
      endpoint_map = {
        for k_end, v_end in v.endpoint_map == null ? merge(var.endpoint_map_standard_default, var.endpoint_map_custom_default) : v.endpoint_map : k_end => merge(
          {
            for k_attr, v_attr in local.lx_map[replace("${k}_${k_end}", "-", "_")] : k_attr => v_attr if !contains(["iam_policy_json"], k_attr)
          },
          {
            az_map = {
              for k_az in local.lx_map[replace("${k}_${k_end}", "-", "_")].vpc_az_key_list : k_az => {
                endpoint_arn                       = aws_vpc_endpoint.this_endpoint[replace("${k}_${k_end}", "-", "_")].arn
                endpoint_cidr_list                 = aws_vpc_endpoint.this_endpoint[replace("${k}_${k_end}", "-", "_")].cidr_blocks
                endpoint_dns                       = aws_vpc_endpoint.this_endpoint[replace("${k}_${k_end}", "-", "_")].dns_entry
                endpoint_id                        = aws_vpc_endpoint.this_endpoint[replace("${k}_${k_end}", "-", "_")].id
                endpoint_network_interface_id_list = aws_vpc_endpoint.this_endpoint[replace("${k}_${k_end}", "-", "_")].network_interface_ids
                endpoint_prefix_list_id            = aws_vpc_endpoint.this_endpoint[replace("${k}_${k_end}", "-", "_")].prefix_list_id
                endpoint_requester_managed         = aws_vpc_endpoint.this_endpoint[replace("${k}_${k_end}", "-", "_")].requester_managed
              }
            }
          },
        )
      }
    })
  }
}
