resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${var.std_map.resource_name_prefix}metrics${var.std_map.resource_name_suffix}"
  dashboard_body = jsonencode(local.dashboard_body)
}
