resource "aws_cloudwatch_log_group" "this_log_group" {
  for_each          = local.lx_map
  kms_key_id        = each.value.kms_key_id
  log_group_class   = each.value.log_group_class
  name              = each.value.name_effective
  retention_in_days = each.value.log_retention_days
  skip_destroy      = each.value.skip_destroy
  tags              = each.value.tags
}
