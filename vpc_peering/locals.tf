module "name_map" {
  source   = "../name_map"
  name_map = var.vpc_data_map
  std_map  = var.std_map
}

locals {
  data_peer_rt_flattened_list = distinct(flatten([
    for k, v in local.l1_map : [
      for k_peer, v_peer in v.peer_map : k_peer if !v_peer.peer_id_is_key && v_peer.manage_remote_routes
    ]
  ]))
  data_peer_rt_flattened_map = {
    for v in local.data_peer_rt_flattened_list : v => {}
  }
  data_peer_rt_id_list_map = {
    for k, _ in local.data_peer_rt_flattened_map : k => sort([
      data.aws_route_tables.peer_routes[k].ids
    ])
  }
  data_peer_vpc_flattened_list = distinct(flatten([
    for k, v in local.l1_map : flatten([
      for k_peer, v_peer in v.peer_map : k_peer if !v_peer.peer_id_is_key
    ])
  ]))
  data_peer_vpc_flattened_map = {
    for v in local.data_peer_vpc_flattened_list : v.k_vpc_peer => {}
  }
  l1_map = {
    for k, v in var.vpc_data_map : k => merge(v, module.name_map.data[k], {
      connection_auto_accept = false
      peer_account_id        = var.std_map.aws_account_id  # TODO: cross-account: second provider, may be null to disable
      peer_region            = var.std_map.aws_region_name # TODO: cross-region: second provider
      peer_map = v.peer_map == null ? {} : {
        for k_peer, v_peer in v.peer_map : k_peer => merge(v_peer, {
          allow_remote_dns_resolution      = v_peer.allow_remote_dns_resolution == null ? var.vpc_allow_remote_dns_resolution_default : v_peer.allow_remote_dns_resolution
          accepter_auto_accept             = v_peer.accepter_auto_accept == null ? var.vpc_accepter_auto_accept_default : v_peer.accepter_auto_accept
          manage_remote_routes             = v_peer.manage_remote_routes == null ? var.vpc_manage_remote_routes_default : v_peer.manage_remote_routes
          peer_allow_remote_dns_resolution = v_peer.peer_allow_remote_dns_resolution == null ? var.vpc_peer_allow_remote_dns_resolution_default : v_peer.peer_allow_remote_dns_resolution
          peer_id_is_key                   = contains(keys(var.vpc_data_map), k_peer)
          k_peer                           = replace(k_peer, "/[._]/", "-")
        })
      }
    })
  }
  l2_map = {
    for k, v in var.vpc_data_map : k => {
      peer_map = {
        for k_peer, v_peer in local.l1_map[k].peer_map : k_peer => merge(v_peer, {
          k_vpc_peer               = "${local.l1_map[k].name_simple}-${v_peer.k_peer}"
          peer_vpc_cidr_block      = v_peer.peer_id_is_key ? var.vpc_data_map[k_peer].vpc_cidr_block : data.aws_vpc.peer_vpc[k_peer].cidr_block
          peer_vpc_id              = v_peer.peer_id_is_key ? local.l1_map[k_peer].vpc_id : k_peer
          peer_vpc_ipv6_cidr_block = v_peer.peer_id_is_key ? local.l1_map[k_peer].vpc_ipv6_cidr_block : data.aws_vpc.peer_vpc[k_peer].ipv6_cidr_block
        })
      }
    }
  }
  l3_map = {
    for k, v in var.vpc_data_map : k => {
      peer_map = {
        for k_peer, v_peer in local.l2_map[k].peer_map : k_peer => merge(v_peer, {
          peer_is_ipv6_routable = local.l1_map[k].vpc_ipv6_cidr_block != null && v_peer.peer_vpc_ipv6_cidr_block != null
          peer_route_list = v_peer.peer_id_is_key ? flatten(
            [
              for k_seg, v_seg in var.vpc_data_map[k_peer].segment_map : [
                for k_az, v_az in v_seg.subnet_map : {
                  k_vpc_peer_rt       = "${v_peer.k_vpc_peer}-${replace(k_seg, "/[._]/", "-")}-${replace(k_az, "/[._]/", "-")}"
                  peer_route_table_id = v_az.route_table_id
                }
              ] if v_seg.route_internal
            ]
            ) : v_peer.manage_remote_routes ? flatten(
            [
              for rt_id in local.data_peer_rt_id_list_map[k_peer] : {
                k_vpc_peer_rt       = "${v_peer.k_vpc_peer}-${rt_id}"
                peer_route_table_id = rt_id
              }
            ]
          ) : []
          tags = merge(var.std_map.tags, {
            Name = "${var.std_map.resource_name_prefix}${v_peer.k_vpc_peer}${var.std_map.resource_name_suffix}"
          })
        })
      }
      segment_map = {
        for k_seg, v_seg in v.segment_map : k_seg => merge(v_seg, {
          subnet_map = {
            for k_az, v_az in v_seg.subnet_map : k_az => merge(v_az, {
              peer_map = {
                for k_peer, v_peer in local.l2_map[k].peer_map : k_peer => {
                  k_vpc_peer               = v_peer.k_vpc_peer
                  k_vpc_peer_seg_az        = "${local.l1_map[k].name_simple}-${v_peer.k_peer}-${replace(k_seg, "/[._]/", "-")}-${replace(k_az, "/[._]/", "-")}"
                  peer_vpc_cidr_block      = v_peer.peer_vpc_cidr_block
                  peer_vpc_ipv6_cidr_block = v_peer.peer_vpc_ipv6_cidr_block
                }
              }
            })
          }
        })
      }
    }
  }
  l4_map = {
    for k, v in var.vpc_data_map : k => {
      segment_map = {
        for k_seg, v_seg in local.l3_map[k].segment_map : k_seg => merge(v_seg, {
          subnet_map = {
            for k_az, v_az in v_seg.subnet_map : k_az => merge(v_az, {
              peer_map = {
                for k_peer, v_peer in v_az.peer_map : k_peer => merge(v_peer, {
                  peer_is_ipv6_routable = local.l3_map[k].peer_map[k_peer].peer_is_ipv6_routable
                })
              }
            })
          }
        })
      }
    }
  }
  output_data = {
    for k, v in local.vpc_map : k => merge(v, {
    })
  }
  peer_flattened_list = flatten([
    for k, v in local.vpc_map : [
      for k_peep, v_peer in v.peer_map : merge(v, v_peer)
    ]
  ])
  peer_flattened_map = {
    for v in local.peer_flattened_list : v.k_vpc_peer => v
  }
  peer_route_flattened_list = flatten([
    for k, v in local.vpc_map : flatten([
      for k_peer, v_peer in v.peer_map : [
        for v_rt in v_peer.peer_route_list : merge(v, v_peer, v_rt)
      ]
    ])
  ])
  peer_route_flattened_map = {
    for v in local.peer_route_flattened_list : v.k_vpc_peer_rt => v
  }
  peer_route_ipv6_flattened_map = {
    for k, v in local.peer_route_flattened_map : k => v if v.peer_is_ipv6_routable
  }
  route_flattened_list = flatten([
    for k, v in local.vpc_map : flatten([
      for k_seg, v_seg in v.segment_map : flatten([
        for k_az, v_az in v_seg.subnet_map : [
          for k_peer_rt, v_peer in v_az.peer_map : merge(v, v_seg, v_az, v_peer)
        ] if v_seg.route_internal
      ])
    ])
  ])
  route_flattened_map = {
    for v in local.route_flattened_list : v.k_vpc_peer_seg_az => v
  }
  route_ipv6_flattened_map = {
    for k, v in local.route_flattened_map : k => v if v.peer_is_ipv6_routable
  }
  vpc_map = {
    for k, v in var.vpc_data_map : k => merge(local.l1_map[k], local.l2_map[k], local.l3_map[k], local.l4_map[k])
  }
}
