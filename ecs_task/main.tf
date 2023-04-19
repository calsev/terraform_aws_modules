module "this_event_bus" {
  source = "../event_bus"
  bus_map = var.schedule_expression == null ? {} : { # TODO: Other event types
    (var.name) = {}
  }
  iam_data = var.iam_data
  std_map  = var.std_map
}

module "this_trigger" {
  source = "../event_trigger"
  event_map = var.schedule_expression == null ? {} : {
    (var.name) = {
      schedule_expression = var.schedule_expression
      definition_arn      = local.task_definition_arn_latest
      target_arn          = var.ecs_cluster_arn
    }
  }
  event_target_service_default = "ecs"
  iam_data                     = var.iam_data
  std_map                      = var.std_map
}
