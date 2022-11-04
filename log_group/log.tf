resource "aws_cloudwatch_log_group" "this_log_group" {
  name              = local.resource_name
  retention_in_days = var.log_retention_days
  tags              = local.tags
}
