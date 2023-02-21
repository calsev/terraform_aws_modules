resource "aws_cloudwatch_log_group" "this_log_group" {
  for_each          = local.log_map
  name              = each.value.resource_name
  retention_in_days = each.value.log_retention_days
  tags              = each.value.tags
}
