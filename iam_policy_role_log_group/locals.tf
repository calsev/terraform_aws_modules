locals {
  log_group_arn = "arn:${var.std_map.iam_partition}:logs:${var.std_map.aws_region_name}:${var.std_map.aws_account_id}:log-group:${var.log_group_name}"
}
