resource "aws_cloudwatch_log_metric_filter" "this_metric" {
  for_each       = local.lx_map
  log_group_name = each.value.log_group_name
  metric_transformation {
    default_value = each.value.transformation_default_value
    dimensions    = each.value.transformation_dimension_map
    name          = each.value.transformation_name
    namespace     = each.value.transformation_namespace
    unit          = each.value.transformation_unit
    value         = each.value.transformation_value
  }
  name    = each.value.name_effective
  pattern = each.value.pattern
}
