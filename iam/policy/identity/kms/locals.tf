locals {
  service_name = "kms"
  resource_arn = startswith(var.key_name, "arn:") ? var.key_name : "arn:${var.std_map.iam_partition}:${local.service_name}:${var.std_map.aws_region_name}:${var.std_map.aws_account_id}:${var.key_name}"
  resource_map = {
    key  = [local.resource_arn]
    star = ["*"]
  }
}
