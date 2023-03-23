locals {
  availability_zone_name_list   = data.aws_availability_zones.available.names
  availability_zone_letter_list = ["a", "b", "c", "d", "e", "f"]
  nat_flattened_list = flatten([
    for k, v in local.vpc_map : [
      for k_az, v_az in v.nat_gateway_map : merge(v, v_az)
    ]
  ])
  nat_flattened_map = {
    for v in local.nat_flattened_list : v.k_az_only => v
  }
  subnet_list_map = {
    for k, v in local.vpc_map : k => sort(flatten([
      for k_seg, v_seg in v.segment_map : [
        for k_az, v_az in v_seg.subnet_map : aws_subnet.this_subnet[v_az.k_az_full].id
      ]
    ]))
  }
  eog_map = {
    for k, v in local.vpc_map : k => v if v.vpc_assign_ipv6_cidr
  }
  l1_map = {
    for k, v in var.vpc_map : k => merge(v, {
      availability_zone_count = v.availability_zone_count == null ? var.vpc_availability_zone_count_default : v.availability_zone_count
      nat_gateway_enabled     = v.nat_gateway_enabled == null ? var.vpc_nat_gateway_enabled_default : v.nat_gateway_enabled
      nat_gateway_multi_az    = v.nat_gateway_multi_az == null ? var.vpc_nat_gateway_multi_az_default : v.nat_gateway_multi_az
      segment_index_map = {
        for i_seg, k_seg in keys(v.segment_map) : k_seg => i_seg
      }
      vpc_assign_ipv6_cidr = v.vpc_assign_ipv6_cidr == null ? var.vpc_assign_ipv6_cidr_default : v.vpc_assign_ipv6_cidr
      vpc_name             = replace(k, "/_/", "-")
    })
  }
  l2_map = {
    for k, v in var.vpc_map : k => {
      nat_gateway_availability_zone_list = local.l1_map[k].nat_gateway_enabled ? local.l1_map[k].nat_gateway_multi_az ? slice(local.availability_zone_letter_list, 0, local.l1_map[k].availability_zone_count) : [local.availability_zone_letter_list[0]] : []
      resource_name                      = "${var.std_map.resource_name_prefix}${local.l1_map[k].vpc_name}${var.std_map.resource_name_suffix}"
      segment_map = {
        for k_seg, v_seg in v.segment_map : k_seg => merge(v_seg, {
          assign_ipv6_address       = local.l1_map[k].vpc_assign_ipv6_cidr
          dns_private_hostname_type = local.l1_map[k].vpc_assign_ipv6_cidr ? "resource-name" : "ip-name"
          k_seg                     = k_seg
          k_seg_full                = "${k}-${k_seg}"
          k_vpc                     = k
          route_internal            = v_seg.route_internal == null ? var.vpc_segment_route_internal_default : v_seg.route_internal
          route_public              = v_seg.route_public == null ? var.vpc_segment_route_public_default : v_seg.route_public
          subnet_bit_length         = v.subnet_bit_length == null ? ceil(log(length(v.segment_map) * local.l1_map[k].availability_zone_count, 2)) : v.subnet_bit_length
          subnet_map = {
            for i_az in range(local.l1_map[k].availability_zone_count) : local.availability_zone_letter_list[i_az] => {
              availability_zone_name = local.availability_zone_name_list[i_az]
              cidr_block_index       = length(v.segment_map) * i_az + local.l1_map[k].segment_index_map[k_seg]
            }
          }
          tags = merge(
            var.std_map.tags,
            {
              Name = "${var.std_map.resource_name_prefix}${local.l1_map[k].vpc_name}-${lower(replace(k_seg, "/_/", "-"))}${var.std_map.resource_name_suffix}"
            }
          )
        })
      }
    }
  }
  l3_map = {
    for k, v in var.vpc_map : k => {
      public_subnet_list = [for k_seg, v_seg in local.l2_map[k].segment_map : k_seg if v_seg.route_public]
      segment_map = {
        for k_seg, v_seg in local.l2_map[k].segment_map : k_seg => merge(v_seg, {
          route_eog       = local.l1_map[k].vpc_assign_ipv6_cidr && !v_seg.route_public
          route_nat       = local.l1_map[k].nat_gateway_enabled && !v_seg.route_public
          route_public_v6 = local.l1_map[k].vpc_assign_ipv6_cidr && v_seg.route_public
          subnet_map = {
            for k_az, v_az in v_seg.subnet_map : k_az => merge(v_az, {
              cidr_block = cidrsubnet(v.vpc_cidr, v_seg.subnet_bit_length, v_az.cidr_block_index)
              k_az       = k_az
              k_az_full  = "${k}-${k_seg}-${k_az}"
              k_az_only  = "${k}-${k_az}"
              k_az_nat   = local.l1_map[k].nat_gateway_multi_az ? "${k}-${k_az}" : "${k}-${local.l2_map[k].nat_gateway_availability_zone_list[0]}"
              tags = merge(
                var.std_map.tags,
                {
                  Name = "${var.std_map.resource_name_prefix}${local.l1_map[k].vpc_name}-${lower(replace(k_seg, "/_/", "-"))}-${k_az}${var.std_map.resource_name_suffix}"
                }
              )
            })
          }
        })
      }
      tags = merge(
        var.std_map.tags,
        {
          Name = local.l2_map[k].resource_name
        }
      )
    }
  }
  l4_map = {
    for k, v in var.vpc_map : k => {
      nat_gateway_map = {
        for k_az in local.l2_map[k].nat_gateway_availability_zone_list : k_az => {
          k_az      = k_az
          k_seg     = local.l3_map[k].public_subnet_list[0]
          k_az_full = "${k}-${local.l3_map[k].public_subnet_list[0]}-${k_az}"
          k_az_only = "${k}-${k_az}"
          k_vpc     = k
          tags = merge(
            var.std_map.tags,
            {
              Name = "${var.std_map.resource_name_prefix}${local.l1_map[k].vpc_name}-${k_az}${var.std_map.resource_name_suffix}"
            }
          )
        }
      }
    }
  }
  output_data = {
    availability_zone_name_list = local.availability_zone_name_list
    vpc_map = {
      for k, v in local.vpc_map : k => merge(v, {
        segment_map = {
          for k_seg, v_seg in v.segment_map : k_seg => merge(v_seg, {
            subnet_id_map = {
              for k_az, v_az in v_seg.subnet_map : k_az => aws_subnet.this_subnet[v_az.k_az_full].id
            }
            subnet_map = {
              for k_az, v_az in v_seg.subnet_map : k_az => merge(v_az, {
                route_table_id = aws_route_table.this_route_table[v_az.k_az_full].id
                subnet_id      = aws_subnet.this_subnet[v_az.k_az_full].id
              })
            }
          })
        }
        vpc_cidr_block      = aws_vpc.this_vpc[k].cidr_block
        vpc_id              = aws_vpc.this_vpc[k].id
        vpc_ipv6_cidr_block = aws_vpc.this_vpc[k].ipv6_cidr_block
      })
    }
  }
  subnet_flattened_list = flatten([
    for k, v in local.vpc_map : flatten([
      for k_seg, v_seg in v.segment_map : flatten([
        for k_az, v_az in v_seg.subnet_map : merge(v_seg, v_az)
      ])
    ])
  ])
  subnet_flattened_eog_map = {
    for k, v in local.subnet_flattened_map : k => v if v.route_eog
  }
  subnet_flattened_map = {
    for subnet in local.subnet_flattened_list : "${subnet.k_vpc}-${subnet.k_seg}-${subnet.k_az}" => subnet
  }
  subnet_flattened_nat_map = {
    for k, v in local.subnet_flattened_map : k => v if v.route_nat
  }
  subnet_flattened_public_map = {
    for k, v in local.subnet_flattened_map : k => v if v.route_public
  }
  subnet_flattened_public_v6_map = {
    for k, v in local.subnet_flattened_map : k => v if v.route_public_v6
  }
  vpc_map = {
    for k, v in var.vpc_map : k => merge(local.l1_map[k], local.l2_map[k], local.l3_map[k], local.l4_map[k])
  }
}
