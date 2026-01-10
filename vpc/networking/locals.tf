locals {
  availability_zone_letter_list = ["a", "b", "c", "d", "e", "f"]
  eog_map = {
    for k, v in local.lx_map : k => v if v.vpc_assign_ipv6_cidr
  }
  l0_map = {
    for k, v in var.vpc_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, {
      availability_zone_map_key_list           = v.availability_zone_map_key_list == null ? var.vpc_availability_zone_map_key_list_default : v.availability_zone_map_key_list
      nacl_egress_map                          = v.nacl_egress_map == null ? var.vpc_nacl_egress_map_default : v.nacl_egress_map
      nacl_ingress_map                         = v.nacl_ingress_map == null ? var.vpc_nacl_ingress_map_default : v.nacl_ingress_map
      nat_multi_az                             = v.nat_multi_az == null ? var.vpc_nat_multi_az_default : v.nat_multi_az
      public_subnet_assign_public_ip_on_launch = v.public_subnet_assign_public_ip_on_launch == null ? var.vpc_public_subnet_assign_public_ip_on_launch_default : v.public_subnet_assign_public_ip_on_launch
      segment_map                              = v.segment_map == null ? var.vpc_segment_map_default : v.segment_map
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      availability_zone_count = length(local.l1_map[k].availability_zone_map_key_list)
    }
  }
  l3_map = {
    for k, v in local.l0_map : k => {
      nat_availability_zone_list = slice(local.availability_zone_letter_list, 0, local.l1_map[k].nat_multi_az ? local.l2_map[k].availability_zone_count : 1)
      segment_index_map = {
        for i_seg, k_seg in keys(local.l1_map[k].segment_map) : k_seg => i_seg
      }
      segment_map = {
        for k_seg, v_seg in local.l1_map[k].segment_map : k_seg => merge(v_seg, {
          assign_ipv6_address       = local.l1_map[k].vpc_assign_ipv6_cidr
          dns_private_hostname_type = local.l1_map[k].vpc_assign_ipv6_cidr ? "resource-name" : "ip-name"
          k_vpc                     = k
          route_internal            = v_seg.route_internal == null ? var.vpc_segment_route_internal_default : v_seg.route_internal
          route_public              = v_seg.route_public == null ? var.vpc_segment_route_public_default : v_seg.route_public
          subnet_map = {
            for i_az in range(local.l2_map[k].availability_zone_count) : local.availability_zone_letter_list[i_az] => {
              availability_zone_name = "${var.std_map.aws_region_name}${local.l1_map[k].availability_zone_map_key_list[i_az]}"
              i_az                   = i_az
            }
          }
          tags = merge(
            var.std_map.tags,
            {
              Name = "${var.std_map.resource_name_prefix}${local.l1_map[k].name_simple}-${lower(replace(k_seg, var.std_map.name_replace_regex, "-"))}${var.std_map.resource_name_suffix}"
            }
          )
        })
      }
      subnet_bit_length                 = v.subnet_bit_length == null ? ceil(log(length(local.l1_map[k].segment_map) * local.l2_map[k].availability_zone_count, 2)) : v.subnet_bit_length
      vpc_availability_zone_letter_list = slice(local.availability_zone_letter_list, 0, local.l2_map[k].availability_zone_count)
    }
  }
  l4_map = {
    for k, v in local.l0_map : k => {
      non_public_segment_list = [for k_seg, v_seg in local.l3_map[k].segment_map : k_seg if !v_seg.route_public]
      public_segment_list     = [for k_seg, v_seg in local.l3_map[k].segment_map : k_seg if v_seg.route_public]
      segment_map = {
        for k_seg, v_seg in local.l3_map[k].segment_map : k_seg => merge(v_seg, {
          route_eog       = local.l1_map[k].vpc_assign_ipv6_cidr && !v_seg.route_public
          route_public_v6 = local.l1_map[k].vpc_assign_ipv6_cidr && v_seg.route_public
          subnet_map = {
            for k_az, v_az in v_seg.subnet_map : k_az => merge(v_az, {
              assign_public_ip_on_launch = local.l1_map[k].public_subnet_assign_public_ip_on_launch && v_seg.route_public
              cidr_block_index           = length(local.l3_map[k].segment_map) * v_az.i_az + local.l3_map[k].segment_index_map[k_seg]
              k_az_full                  = "${k}_${k_seg}_${k_az}"
              k_az_nat                   = local.l1_map[k].nat_multi_az ? "${k}_${k_az}" : "${k}_${local.l3_map[k].nat_availability_zone_list[0]}"
              k_az_only                  = "${k}_${k_az}"
              tags = merge(
                var.std_map.tags,
                {
                  Name = "${var.std_map.resource_name_prefix}${local.l1_map[k].name_simple}-${lower(replace(k_seg, var.std_map.name_replace_regex, "-"))}-${k_az}${var.std_map.resource_name_suffix}"
                }
              )
            })
          }
        })
      }
    }
  }
  l5_map = {
    for k, v in local.l0_map : k => {
      k_az_list = sort(flatten([
        for _, v_seg in local.l4_map[k].segment_map : [
          for _, v_az in v_seg.subnet_map : v_az.k_az_full
        ]
      ]))
      nat_instance_enabled = length(local.l4_map[k].non_public_segment_list) == 0 ? false : v.nat_instance_enabled == null ? var.vpc_nat_instance_enabled_default : v.nat_instance_enabled
      nat_map = {
        for k_az in local.l3_map[k].nat_availability_zone_list : k_az => {
          k_az      = k_az
          k_seg     = local.l4_map[k].public_segment_list[0]
          k_az_full = "${k}_${local.l4_map[k].public_segment_list[0]}_${k_az}"
          k_az_only = "${k}_${k_az}"
          k_vpc     = k
          tags = merge(
            var.std_map.tags,
            {
              Name = "${var.std_map.resource_name_prefix}${local.l1_map[k].name_simple}-${k_az}${var.std_map.resource_name_suffix}"
            }
          )
        }
      }
      segment_map = {
        for k_seg, v_seg in local.l4_map[k].segment_map : k_seg => merge(v_seg, {
          subnet_map = {
            for k_az, v_az in v_seg.subnet_map : k_az => merge(v_az, {
              subnet_cidr_block = cidrsubnet(v.vpc_cidr_block, local.l3_map[k].subnet_bit_length, v_az.cidr_block_index)
            })
          }
        })
      }
    }
  }
  l6_map = {
    for k, v in local.l0_map : k => {
      nat_gateway_enabled = local.l5_map[k].nat_instance_enabled ? false : length(local.l4_map[k].non_public_segment_list) == 0 ? false : v.nat_gateway_enabled == null ? var.vpc_nat_gateway_enabled_default : v.nat_gateway_enabled
      segment_map = {
        for k_seg, v_seg in local.l5_map[k].segment_map : k_seg => merge(v_seg, {
          route_nat_instance = local.l5_map[k].nat_instance_enabled && !v_seg.route_public
        })
      }
    }
  }
  l7_map = {
    for k, v in local.l0_map : k => {
      nat_enabled = local.l5_map[k].nat_instance_enabled || local.l6_map[k].nat_gateway_enabled
      segment_map = {
        for k_seg, v_seg in local.l6_map[k].segment_map : k_seg => merge(v_seg, {
          route_nat_v6      = local.l1_map[k].vpc_assign_ipv6_cidr && local.l6_map[k].nat_gateway_enabled # Must have ipv6 route to NAT or dnsv6 blackholes AWS endpoint requests
          route_nat_gateway = local.l6_map[k].nat_gateway_enabled && !v_seg.route_public
        })
      }
    }
  }
  l8_map = {
    for k, v in local.l0_map : k => {
      segment_map = {
        for k_seg, v_seg in local.l7_map[k].segment_map : k_seg => merge(v_seg, {
          dns64_enabled = v_seg.route_nat_v6 ? v.dns64_enabled == null ? var.vpc_dns64_enabled_default : v.dns64_enabled : false # Must have ipv6 route to NAT or dnsv6 blackholes AWS endpoint requests
        })
      }
    }
  }
  lx_map = {
    for k, v in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k], local.l3_map[k], local.l4_map[k], local.l5_map[k], local.l6_map[k], local.l7_map[k], local.l8_map[k])
  }
  nat_flattened_list = flatten([
    for k, v in local.lx_map : [
      for k_az, v_az in v.nat_map : merge(v, v_az)
    ] if v.nat_enabled
  ])
  nat_flattened_map = {
    for v in local.nat_flattened_list : v.k_az_only => v
  }
  nat_gateway_flattened_map = {
    for k, v in local.nat_flattened_map : k => v if v.nat_gateway_enabled
  }
  nat_instance_flattened_map = {
    for k, v in local.nat_flattened_map : k => v if v.nat_instance_enabled
  }
  nat_instance_vpc_data_map = {
    for k, v in local.lx_map : k => merge(v, {
      segment_map = {
        for k_seg, v_seg in v.segment_map : k_seg => {
          route_public = v_seg.route_public
          subnet_id_map = {
            for k_az, v_az in v_seg.subnet_map : k_az => aws_subnet.this_subnet[v_az.k_az_full].id
          }
          subnet_map = {
            for k_az, v_az in v_seg.subnet_map : k_az => merge(v_az, {
              route_table_id = aws_route_table.this_route_table[v_az.k_az_full].id
              subnet_id      = aws_subnet.this_subnet[v_az.k_az_full].id
            })
          }
        }
      }
    })
  }
  output_data = {
    vpc_map = {
      for k, v in local.lx_map : k => merge(v, {
        instance_connect_endpoint = module.instance_connect_endpoint.data[k]
        nat_map = {
          for k_az, v_az in v.nat_map : k_az => merge(v_az, {
            nat_gateway  = v.nat_gateway_enabled ? module.nat_gateway.data[v_az.k_az_only] : null
            nat_instance = v.nat_instance_enabled ? module.nat_instance.data[v_az.k_az_only] : null
          })
        }
        segment_map = {
          for k_seg, v_seg in v.segment_map : k_seg => merge(v_seg, {
            subnet_id_map = local.nat_instance_vpc_data_map[k].segment_map[k_seg].subnet_id_map
            subnet_map    = local.nat_instance_vpc_data_map[k].segment_map[k_seg].subnet_map
          })
        }
      })
    }
  }
  subnet_flattened_list = flatten([
    for k, v in local.lx_map : flatten([
      for k_seg, v_seg in v.segment_map : [
        for k_az, v_az in v_seg.subnet_map : merge(v, v_seg, v_az)
      ]
    ])
  ])
  subnet_flattened_eog_map = {
    for k, v in local.subnet_flattened_map : k => v if v.route_eog
  }
  subnet_flattened_map = {
    for subnet in local.subnet_flattened_list : subnet.k_az_full => subnet
  }
  subnet_flattened_nat_gateway_map = {
    for k, v in local.subnet_flattened_map : k => v if v.route_nat_gateway
  }
  subnet_flattened_nat_instance_map = {
    for k, v in local.subnet_flattened_map : k => v if v.route_nat_instance
  }
  subnet_flattened_nat_ipv6_map = {
    for k, v in local.subnet_flattened_map : k => v if v.route_nat_v6
  }
  subnet_flattened_public_map = {
    for k, v in local.subnet_flattened_map : k => v if v.route_public
  }
  subnet_flattened_public_v6_map = {
    for k, v in local.subnet_flattened_map : k => v if v.route_public_v6
  }
  subnet_flattened_id_map = {
    for k, v in local.subnet_flattened_map : k => aws_subnet.this_subnet[k].id
  }
}
