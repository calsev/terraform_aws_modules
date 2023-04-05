data "aws_vpc" "peer_vpc" {
  for_each = local.data_peer_vpc_flattened_map
  id       = each.value
}

data "aws_route_tables" "peer_routes" {
  for_each = local.data_peer_rt_flattened_map
  vpc_id   = each.value
}
