module "this_event_bus" {
  source = "../event_bus"
  bus_map = var.cron_expression == null ? {} : { # TODO: Other event types
    (var.name) = {}
  }
  std_map = var.std_map
}

module "this_trigger" {
  source = "../event_trigger"
  event_map = var.cron_expression == null ? {} : {
    (var.name) = {
      cron_expression         = var.cron_expression
      definition_arn          = local.task_definition_arn_latest
      iam_role_arn_start_task = var.iam_data.iam_role_arn_ecs_start_task
      target_arn              = var.ecs_cluster_arn
    }
  }
  std_map = var.std_map
}
