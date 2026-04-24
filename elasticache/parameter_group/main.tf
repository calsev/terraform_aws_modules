resource "aws_elasticache_parameter_group" "this_group" {
  for_each = local.lx_map
  family   = each.value.family
  name     = each.value.name_effective
  dynamic "parameter" {
    for_each = each.value.parameter_map
    content {
      name  = parameter.key
      value = parameter.value
    }
  }
  region = var.std_map.aws_region_name
  tags   = each.value.tags
}
