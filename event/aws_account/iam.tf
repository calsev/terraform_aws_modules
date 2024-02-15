# There is a limit on number of resource policies, so trust events globally
module "log_trust_policy" {
  source         = "../../iam/policy/resource/cw/log_group"
  log_group_name = "*" # This could be /aws/events/* for events.amazonaws.com, but do not get frivolous with resource policies
  policy_name    = "DefaultLogGroupAllowEvents"
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
    LogDelivery = {
      access = "write"
      condition_map = {
        source_account = local.source_account_condition
        source_arn = {
          test = "ArnLike"
          value_list = [
            "arn:${var.std_map.iam_partition}:logs:${var.std_map.aws_region_name}:${var.std_map.aws_account_id}:*",
          ]
          variable = "AWS:SourceArn"
        }
      }
      identifier_list = ["delivery.logs.amazonaws.com"]
      identifier_type = "Service"
    }
  }
  std_map = var.std_map
}
