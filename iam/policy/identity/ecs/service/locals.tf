locals {
  service_arn = startswith(var.service_name, "arn:") ? var.service_name : "arn:${var.std_map.iam_partition}:ecs:${var.std_map.aws_region_name}:${var.std_map.aws_account_id}:service/${var.cluster_name}/${var.service_name}"
}
