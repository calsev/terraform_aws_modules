resource "aws_elasticache_parameter_group" "this_group" {
  for_each = local.lx_map
  name     = each.value.name_effective
  family   = each.value.family
  tags     = each.value.tags
  dynamic "parameter" {
    for_each = each.value.parameter_map
    content {
      name  = parameter.key
      value = parameter.value
    }
  }
}
