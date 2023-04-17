module "subnet_map" {
  source                              = "../vpc_subnet_map"
  vpc_availability_zone_count_default = var.vpc_availability_zone_count_default
  vpc_segment_map_default             = var.vpc_segment_map_default
  vpc_segment_route_internal_default  = var.vpc_segment_route_internal_default
  vpc_segment_route_public_default    = var.vpc_segment_route_public_default
  vpc_map                             = var.vpc_map
}

locals {
  l1_map = {
    for k, v in var.vpc_map : k => merge(v, module.subnet_map.data.vpc_map[k], {
    })
  }
  nat_instance_vpc_data_map = {
    for k, v in local.vpc_map : k => merge(v, {
      segment_map = {
        for k_seg, v_seg in v.segment_map : k_seg => {
          subnet_id_map = {
            for k_az, v_az in v_seg.subnet_map : k_az => aws_subnet.this_subnet[v_az.k_az_full].id
          }
        }
      }
    })
  }
  output_data = {
    vpc_map = {
      for k, v in local.vpc_map : k => merge(v, {
        nat_map = {
          for k_az, v_az in v.nat_map : k_az => merge(v_az, {
            nat_gateway  = v.nat_gateway_enabled ? module.nat_gateway.data[v_az.k_az_only] : null
            nat_instance = v.nat_instance_enabled ? module.nat_instance.data[v_az.k_az_only] : null
          })
        }
        segment_map = {
          for k_seg, v_seg in v.segment_map : k_seg => merge(v_seg, {
            subnet_id_map = local.nat_instance_vpc_data_map[k].segment_map[k_seg].subnet_id_map
            subnet_map = {
              for k_az, v_az in v_seg.subnet_map : k_az => merge(v_az, {
                route_table_id = aws_route_table.this_route_table[v_az.k_az_full].id
                subnet_id      = aws_subnet.this_subnet[v_az.k_az_full].id
              })
            }
          })
        }
      })
    }
  }
  subnet_flattened_list = flatten([
    for k, v in local.vpc_map : flatten([
      for k_seg, v_seg in v.segment_map : [
        for k_az, v_az in v_seg.subnet_map : merge(v, v_seg, v_az)
      ]
    ])
  ])
  subnet_flattened_map = {
    for subnet in local.subnet_flattened_list : subnet.k_az_full => subnet
  }
  subnet_flattened_id_map = {
    for k, v in local.subnet_flattened_map : k => aws_subnet.this_subnet[k].id
  }
  vpc_map = {
    for k, v in var.vpc_map : k => merge(local.l1_map[k])
  }
}
