resource "aws_network_interface" "this_interface" {
  for_each = local.lx_map
  # attachment # TODO
  interface_type            = null
  ipv4_prefix_count         = 0
  ipv4_prefixes             = null # Conflicts with ipv4_prefix_count
  ipv6_address_count        = each.value.ipv6_address_count
  ipv6_address_list_enabled = false
  ipv6_address_list         = null # Conflicts with ipv6_address_count
  ipv6_addresses            = null # Conflicts with ipv6_address_count
  ipv6_prefix_count         = 0
  ipv6_prefixes             = null # Conflicts with ipv6_prefix_count
  private_ip_list           = null # Conflicts with private_ips
  private_ip_list_enabled   = false
  private_ips               = []
  private_ips_count         = each.value.private_ip_count
  security_groups           = each.value.vpc_security_group_id_list
  source_dest_check         = true # TODO
  subnet_id                 = each.value.vpc_subnet_id_list[0]
  tags                      = each.value.tags
}
