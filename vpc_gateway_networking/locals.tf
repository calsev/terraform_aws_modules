locals {
  eog_map = {
    for k, v in local.vpc_map : k => v if v.vpc_assign_ipv6_cidr
  }
  l1_map = {
    for k, v in var.vpc_map : k => merge(v, {
      nat_multi_az = v.nat_multi_az == null ? var.vpc_nat_multi_az_default : v.nat_multi_az
    })
  }
  l2_map = {
    for k, v in var.vpc_map : k => {
      nat_availability_zone_list = local.l1_map[k].nat_multi_az ? slice(var.vpc_subnet_map_data.availability_zone_letter_list, 0, local.l1_map[k].availability_zone_count) : [var.vpc_subnet_map_data.availability_zone_letter_list[0]]
    }
  }
  l3_map = {
    for k, v in var.vpc_map : k => {
      segment_map = {
        for k_seg, v_seg in local.l2_map[k].segment_map : k_seg => merge(v_seg, {
          route_eog = local.l1_map[k].vpc_assign_ipv6_cidr && !v_seg.route_public
        })
      }
    }
  }
  l4_map = {
    for k, v in var.vpc_map : k => {
      nat_instance_enabled = length(local.l3_map[k].non_public_segment_list) == 0 ? false : v.nat_instance_enabled == null ? var.vpc_nat_instance_enabled_default : v.nat_instance_enabled
      nat_map = {
        for k_az in local.l2_map[k].nat_availability_zone_list : k_az => {
          k_az      = k_az
          k_seg     = local.l3_map[k].public_segment_list[0]
          k_az_full = "${k}-${local.l3_map[k].public_segment_list[0]}-${k_az}"
          k_az_only = "${k}-${k_az}"
          k_vpc     = k
          tags = merge(
            var.std_map.tags,
            {
              Name = "${var.std_map.resource_name_prefix}${local.l1_map[k].name_simple}-${k_az}${var.std_map.resource_name_suffix}"
            }
          )
        }
      }
    }
  }
  l5_map = {
    for k, v in var.vpc_map : k => {
      nat_gateway_enabled = local.l4_map[k].nat_instance_enabled ? false : length(local.l3_map[k].non_public_segment_list) == 0 ? false : v.nat_gateway_enabled == null ? var.vpc_nat_gateway_enabled_default : v.nat_gateway_enabled
      segment_map = {
        for k_seg, v_seg in local.l4_map[k].segment_map : k_seg => merge(v_seg, {
          route_nat_instance = local.l4_map[k].nat_instance_enabled && !v_seg.route_public
        })
      }
    }
  }
  l6_map = {
    for k, v in var.vpc_map : k => {
      nat_enabled = local.l4_map[k].nat_instance_enabled || local.l5_map[k].nat_gateway_enabled
      segment_map = {
        for k_seg, v_seg in local.l5_map[k].segment_map : k_seg => merge(v_seg, {
          route_nat_gateway = local.l5_map[k].nat_gateway_enabled && !v_seg.route_public
        })
      }
    }
  }
  nat_flattened_list = flatten([
    for k, v in local.vpc_map : [
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
  subnet_flattened_eog_map = {
    for k, v in local.subnet_flattened_map : k => v if v.route_eog
  }
  subnet_flattened_nat_gateway_map = {
    for k, v in local.subnet_flattened_map : k => v if v.route_nat_gateway
  }
  subnet_flattened_nat_instance_map = {
    for k, v in local.subnet_flattened_map : k => v if v.route_nat_instance
  }
  subnet_flattened_public_map = {
    for k, v in local.subnet_flattened_map : k => v if v.route_public
  }
  subnet_flattened_public_v6_map = {
    for k, v in local.subnet_flattened_map : k => v if v.route_public_v6
  }
  vpc_map = {
    for k, v in var.vpc_map : k => merge(local.l1_map[k], local.l2_map[k], local.l3_map[k], local.l4_map[k], local.l5_map[k], local.l6_map[k])
  }
}
