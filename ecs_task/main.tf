module "this_event_bus" {
  source   = "../event_bus"
  bus_map  = local.bus_map
  iam_data = var.iam_data
  std_map  = var.std_map
}

module "this_trigger" {
  source = "../event_trigger"
  event_map = {
    for k, v in local.bus_map : k => merge(v, {
      definition_arn = local.o2_map[k].task_definition_arn_latest
      target_arn     = v.ecs_cluster_arn
    })
  }
  event_target_service_default = "ecs"
  iam_data                     = var.iam_data
  std_map                      = var.std_map
}
