locals {
  log_group_arn = startswith(var.log_group_name, "arn:") ? var.log_group_name : "arn:${var.std_map.iam_partition}:logs:${var.std_map.aws_region_name}:${var.std_map.aws_account_id}:log-group:${var.log_group_name}"
  resource_map = {
    group  = ["${local.log_group_arn}:*"]
    stream = ["${local.log_group_arn}:log-stream:*"]
    star   = ["*"]
  }
}
