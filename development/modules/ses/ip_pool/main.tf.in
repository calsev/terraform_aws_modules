resource "aws_sesv2_dedicated_ip_pool" "this_pool" {
  for_each     = local.lx_map
  pool_name    = each.value.name_effective
  scaling_mode = each.value.scaling_mode
  tags         = each.value.tags
}
