module "log_group" {
  source  = "../log_group"
  log_map = local.log_map
  std_map = var.std_map
}

module "log_trigger" {
  source = "../event_trigger"
  event_map = {
    for k, v in local.schema_map : (v.log_name) => {
      event_bus_name = v.event_bus_name
      target_arn     = module.log_group.data[v.log_name].log_group_arn
    }
  }
  event_pattern_json_default = jsonencode({
    source = ["aws.events"]
  })
  std_map = var.std_map
}
