data "aws_vpc" "peer_vpc" {
  for_each = local.data_peer_vpc_flattened_set
  id       = each.key
}

data "aws_route_tables" "peer_routes" {
  for_each = local.data_peer_rt_flattened_set
  vpc_id   = each.key
}
