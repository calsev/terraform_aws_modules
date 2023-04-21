locals {
  service_name = "sns"
  sns_topic_arn = startswith(var.sns_topic_name, "arn:") ? var.sns_topic_name : "arn:${var.std_map.iam_partition}:${local.service_name}:${var.std_map.aws_region_name}:${var.std_map.aws_account_id}:${var.sns_topic_name}"
  resource_map = {
    topic = [local.sns_topic_arn]
  }
}
