resource "aws_vpc_endpoint" "this_endpoint" {
  for_each    = local.lx_map
  auto_accept = each.value.auto_accept_enabled
  dynamic "dns_options" {
    for_each = each.value.dns_enabled ? { this = {} } : {}
    content {
      dns_record_ip_type                             = each.value.dns_record_ip_type
      private_dns_only_for_inbound_resolver_endpoint = each.value.private_dns_for_inbound_resolver_endpoint_only
    }
  }
  ip_address_type     = each.value.ip_address_type
  policy              = each.value.iam_policy_doc == null ? null : jsonencode(each.value.iam_policy_doc)
  private_dns_enabled = each.value.private_dns_enabled
  route_table_ids     = null
  security_group_ids  = each.value.vpc_security_group_id_list
  service_name        = each.value.service_name
  dynamic "subnet_configuration" {
    for_each = each.value.endpoint_subnet_map
    content {
      ipv4      = subnet_configuration.value.ipv4_address
      ipv6      = subnet_configuration.value.ipv6_address
      subnet_id = subnet_configuration.value.vpc_subnet_id
    }
  }
  subnet_ids        = each.value.vpc_subnet_id_eni_list
  tags              = each.value.tags
  vpc_endpoint_type = each.value.endpoint_type
  vpc_id            = each.value.vpc_id
}

resource "aws_vpc_endpoint_route_table_association" "this_association" {
  for_each        = local.create_association_x_map
  route_table_id  = each.value.route_table_id
  vpc_endpoint_id = aws_vpc_endpoint.this_endpoint[each.value.k_end].id
}
