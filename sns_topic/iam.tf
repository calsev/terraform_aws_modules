module "this_policy" {
  for_each = local.topic_policy_map
  source   = "../iam_policy_resource_sns_topic"
  sid_map = {
    Event = {
      access = "write"
      condition_map = {
        source_account = local.source_account_condition
        source_arn = {
          test = "ArnLike"
          value_list = [
            "arn:${var.std_map.iam_partition}:events:${var.std_map.aws_region_name}:${var.std_map.aws_account_id}:rule/*",
          ]
          variable = "AWS:SourceArn"
        }
      }
      identifier_list = ["events.amazonaws.com"]
      identifier_type = "Service"
    }
  }
  sns_topic_name = each.value.name_effective
  std_map        = var.std_map
}
