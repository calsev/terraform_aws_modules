# There is a limit on number of resource policies, so trust events globally
module "log_trust_policy" {
  source         = "../iam_policy_resource_log_group"
  log_group_name = "*"
  sid_map = {
    Event = {
      access = "write"
      condition_map = {
        source_account = local.source_account_condition
        source_arn = {
          test       = "ArnLike"
          value_list = ["arn:aws:logs:us-west-2:${var.std_map.aws_account_id}:*"]
          variable   = "AWS:SourceArn"
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
          test       = "ArnLike"
          value_list = ["arn:aws:logs:us-west-2:${var.std_map.aws_account_id}:*"]
          variable   = "AWS:SourceArn"
        }
      }
      identifier_list = ["delivery.logs.amazonaws.com"]
      identifier_type = "Service"
    }
  }
  std_map = var.std_map
}
