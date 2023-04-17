locals {
  availability_zone_name_list   = data.aws_availability_zones.available.names
  availability_zone_letter_list = ["a", "b", "c", "d", "e", "f"]
  l1_map = {
    for k, v in var.vpc_map : k => merge(v, {
      availability_zone_count = v.availability_zone_count == null ? var.vpc_availability_zone_count_default : v.availability_zone_count
      segment_map             = v.segment_map == null ? var.vpc_segment_map_default : v.segment_map
    })
  }
  l2_map = {
    for k, v in var.vpc_map : k => {
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
            for i_az in range(local.l1_map[k].availability_zone_count) : local.availability_zone_letter_list[i_az] => {
              availability_zone_name = local.availability_zone_name_list[i_az]
              i_az                   = i_az
            }
          }
          tags = merge(
            var.std_map.tags,
            {
              Name = "${var.std_map.resource_name_prefix}${local.l1_map[k].name_simple}-${lower(replace(k_seg, "/_/", "-"))}${var.std_map.resource_name_suffix}"
            }
          )
        })
      }
      subnet_bit_length = v.subnet_bit_length == null ? ceil(log(length(local.l1_map[k].segment_map) * local.l1_map[k].availability_zone_count, 2)) : v.subnet_bit_length
    }
  }
  l3_map = {
    for k, v in var.vpc_map : k => {
      non_public_segment_list = [for k_seg, v_seg in local.l2_map[k].segment_map : k_seg if !v_seg.route_public]
      public_segment_list     = [for k_seg, v_seg in local.l2_map[k].segment_map : k_seg if v_seg.route_public]
      segment_map = {
        for k_seg, v_seg in local.l2_map[k].segment_map : k_seg => merge(v_seg, {
          route_public_v6 = local.l1_map[k].vpc_assign_ipv6_cidr && v_seg.route_public
          subnet_map = {
            for k_az, v_az in v_seg.subnet_map : k_az => merge(v_az, {
              cidr_block_index = length(local.l2_map[k].segment_map) * v_az.i_az + local.l2_map[k].segment_index_map[k_seg]
              k_az_full        = "${k}-${k_seg}-${k_az}"
              k_az_nat         = local.l1_map[k].nat_multi_az ? "${k}-${k_az}" : "${k}-${local.l2_map[k].nat_availability_zone_list[0]}"
              k_az_only        = "${k}-${k_az}"
              tags = merge(
                var.std_map.tags,
                {
                  Name = "${var.std_map.resource_name_prefix}${local.l1_map[k].name_simple}-${lower(replace(k_seg, "/_/", "-"))}-${k_az}${var.std_map.resource_name_suffix}"
                }
              )
            })
          }
        })
      }
    }
  }
  l4_map = {
    for k, v in var.vpc_map : k => {
      k_az_list = sort(flatten([
        for _, v_seg in local.l3_map[k].segment_map : [
          for _, v_az in v_seg.subnet_map : v_az.k_az_full
        ]
      ]))
      segment_map = {
        for k_seg, v_seg in local.l3_map[k].segment_map : k_seg => merge(v_seg, {
          subnet_map = {
            for k_az, v_az in v_seg.subnet_map : k_az => merge(v_az, {
              subnet_cidr_block = cidrsubnet(v.vpc_cidr_block, local.l2_map[k].subnet_bit_length, v_az.cidr_block_index)
            })
          }
        })
      }
    }
  }
  output_data = {
    availability_zone_letter_list = local.availability_zone_letter_list
    vpc_map = {
      for k, v in var.vpc_map : k => merge(local.l1_map[k], local.l2_map[k], local.l3_map[k], local.l4_map[k])
    }
  }
}
