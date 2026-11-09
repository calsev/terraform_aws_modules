resource "aws_docdb_cluster_parameter_group" "this_param_group" {
  for_each    = local.lx_map
  description = null
  family      = each.value.db_family
  name        = each.value.name_effective
  name_prefix = null
  dynamic "parameter" {
    for_each = each.value.param_map
    content {
      apply_method = parameter.value.apply_method
      name         = parameter.key
      value        = parameter.value.value
    }
  }
  region = var.std_map.aws_region_name
  tags   = each.value.tags
}
