locals {
  availability_zone_name_list   = data.aws_availability_zones.available.names
  availability_zone_letter_list = ["a", "b", "c", "d", "e", "f"]
  l1_map = {
    for k, v in var.vpc_map : k => merge(v, {
      vpc_assign_ipv6_cidr = v.vpc_assign_ipv6_cidr == null ? var.vpc_assign_ipv6_cidr_default : v.vpc_assign_ipv6_cidr
      vpc_name             = replace(k, "/_/", "-")
    })
  }
  l2_map = {
    for k, v in var.vpc_map : k => {
      resource_name = "${var.std_map.resource_name_prefix}${local.l1_map[k].vpc_name}${var.std_map.resource_name_suffix}"
      segment_map = {
        for k_seg, v_seg in v.segment_map : k_seg => merge(v_seg, {
          k_seg          = k_seg
          k_seg_full     = "${k}-${k_seg}"
          k_vpc          = k
          route_internal = v_seg.route_internal == null ? var.vpc_segment_route_internal_default : v_seg.route_internal
          route_public   = v_seg.route_public == null ? var.vpc_segment_route_public_default : v_seg.route_public
          subnet_map = {
            for i_az, subnet_cidr in v_seg.subnet_cidr_list : local.availability_zone_letter_list[i_az] => {
              availability_zone_name = local.availability_zone_name_list[i_az]
              k_az                   = local.availability_zone_letter_list[i_az]
              k_az_full              = "${k}-${k_seg}-${local.availability_zone_letter_list[i_az]}"
              subnet_cidr            = subnet_cidr
              tags = merge(
                var.std_map.tags,
                {
                  Name = "${var.std_map.resource_name_prefix}${local.l1_map[k].vpc_name}-${lower(replace(k_seg, "/_/", "-"))}-${local.availability_zone_letter_list[i_az]}${var.std_map.resource_name_suffix}"
                }
              )
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
      tags = merge(
        var.std_map.tags,
        {
          Name = local.l2_map[k].resource_name
        }
      )
    }
  }
  output_data = {
    availability_zone_name_list = local.availability_zone_name_list
    vpc_map = {
      for k, v in local.vpc_map : k => merge(v, {
        segment_map = {
          for k_seg, v_seg in v.segment_map : k_seg => merge(v_seg, {
            route_table_id = aws_route_table.this_route_table[v_seg.k_seg_full].id
            subnet_id_map = {
              for k_az, v_az in v_seg.subnet_map : k_az => aws_subnet.this_subnet[v_az.k_az_full].id
            }
            subnet_map = {
              for k_az, v_az in v_seg.subnet_map : k_az => merge(v_az, {
                subnet_id = aws_subnet.this_subnet[v_az.k_az_full].id
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
  segment_flattened_list = flatten([
    for k, v in local.l2_map : flatten([
      for k_seg, v_seg in v.segment_map : v_seg
    ])
  ])
  segment_flattened_map = {
    for segment in local.segment_flattened_list : "${segment.k_vpc}-${segment.k_seg}" => segment
  }
  segment_flattened_public_map = {
    for k, v in local.segment_flattened_map : k => v if v.route_public
  }
  subnet_flattened_list = flatten([
    for k, v in local.l2_map : flatten([
      for k_seg, v_seg in v.segment_map : flatten([
        for k_az, v_az in v_seg.subnet_map : merge(v_seg, v_az)
      ])
    ])
  ])
  subnet_flattened_map = {
    for subnet in local.subnet_flattened_list : "${subnet.k_vpc}-${subnet.k_seg}-${subnet.k_az}" => subnet
  }
  vpc_map = {
    for k, v in var.vpc_map : k => merge(local.l1_map[k], local.l2_map[k], local.l3_map[k])
  }
}
