# There is a limit on number of resource policies, so trust events globally
module "log_trust_policy" {
  source         = "../../iam/policy/resource/cw/log_group"
  log_group_name = "/*" # This could be /aws/events/* for events.amazonaws.com, but do not get frivolous with resource policies
  name           = "DefaultLogGroupAllowEvents"
  sid_map = {
    EventAndLogDelivery = {
      # At some point the default AWS policy removed the conditions on SourceAccount and SourceArn
      access = "write"
      identifier_list = [
        "delivery.logs.amazonaws.com",
        "events.amazonaws.com",
      ]
      identifier_type = "Service"
    }
  }
  std_map = var.std_map
}
