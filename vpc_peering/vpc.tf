resource "aws_vpc_peering_connection" "this_peering" {
  for_each      = local.peer_flattened_map
  auto_accept   = each.value.connection_auto_accept
  peer_owner_id = each.value.peer_account_id
  peer_region   = each.value.peer_region
  peer_vpc_id   = each.value.peer_vpc_id
  tags          = each.value.tags
  vpc_id        = each.value.vpc_id
}

resource "aws_vpc_peering_connection_options" "this_peering_options" {
  for_each   = local.peer_flattened_map
  depends_on = [aws_vpc_peering_connection_accepter.this_peering_accepter]
  accepter {
    # allow_classic_link_to_remote_vpc deprecated
    allow_remote_vpc_dns_resolution = each.value.peer_allow_remote_dns_resolution
    # allow_vpc_to_remote_classic_link deprecated
  }
  requester {
    # allow_classic_link_to_remote_vpc deprecated
    allow_remote_vpc_dns_resolution = each.value.allow_remote_dns_resolution
    # allow_vpc_to_remote_classic_link deprecated
  }
  vpc_peering_connection_id = aws_vpc_peering_connection.this_peering[each.key].id
}

resource "aws_vpc_peering_connection_accepter" "this_peering_accepter" {
  for_each                  = local.peer_flattened_map
  auto_accept               = each.value.accepter_auto_accept
  tags                      = each.value.tags
  vpc_peering_connection_id = aws_vpc_peering_connection.this_peering[each.key].id
}

resource "aws_route" "to_peer" {
  for_each                  = local.route_flattened_map
  destination_cidr_block    = each.value.peer_vpc_cidr_block
  route_table_id            = each.value.route_table_id
  vpc_peering_connection_id = aws_vpc_peering_connection.this_peering[each.value.k_vpc_peer].id
}

resource "aws_route" "from_peer" {
  for_each                  = local.peer_route_flattened_map
  destination_cidr_block    = each.value.vpc_cidr_block
  route_table_id            = each.value.peer_route_table_id
  vpc_peering_connection_id = aws_vpc_peering_connection.this_peering[each.value.k_vpc_peer].id
}

resource "aws_route" "to_peer_ipv6" {
  for_each                    = local.route_ipv6_flattened_map
  destination_ipv6_cidr_block = each.value.peer_vpc_ipv6_cidr_block
  route_table_id              = each.value.route_table_id
  vpc_peering_connection_id   = aws_vpc_peering_connection.this_peering[each.value.k_vpc_peer].id
}

resource "aws_route" "from_peer_ipv6" {
  for_each                    = local.peer_route_ipv6_flattened_map
  destination_ipv6_cidr_block = each.value.vpc_ipv6_cidr_block
  route_table_id              = each.value.peer_route_table_id
  vpc_peering_connection_id   = aws_vpc_peering_connection.this_peering[each.value.k_vpc_peer].id
}
