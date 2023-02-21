module "log_group" {
  source  = "../log_group"
  log_map = local.log_map
  std_map = var.std_map
}

module "log_policy" {
  source         = "../iam_policy_resource_log_group"
  for_each       = local.log_map
  log_group_name = module.log_group.data[each.key].log_group_name
  sid_map = {
    LogEvent = {
      access          = "write"
      identifier_list = ["events.amazonaws.com"]
      identifier_type = "Service"
    }
  }
  std_map = var.std_map
}

#module "log_trigger" {
#  source = "../event_trigger"
#  event_map = {
#    for k, v in local.schema_map : (v.log_name) => {
#      event_bus_name = v.event_bus_name
#    }
#  }
#  std_map = var.std_map
#}
