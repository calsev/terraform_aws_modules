locals {
  log_group_arn = "arn:${var.std_map.iam_partition}:logs:${var.std_map.aws_region_name}:${var.std_map.aws_account_id}:log-group:${var.log_group_name}"
  resource_map = !contains(var.access_list, "public_read") ? local.resource_map_raw : {
    for k, v in local.resource_map_raw : k => v if k != "star"
  }
  resource_map_raw = {
    group  = ["${local.log_group_arn}:*"]
    stream = ["${local.log_group_arn}:log-stream:*"]
    star   = ["*"]
  }
}
