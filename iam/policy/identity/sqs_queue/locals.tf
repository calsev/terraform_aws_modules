locals {
  queue_arn = startswith(var.queue_name, "arn:") ? var.queue_name : "arn:${var.std_map.iam_partition}:sqs:${var.std_map.aws_region_name}:${var.std_map.aws_account_id}:${var.queue_name}"
}
