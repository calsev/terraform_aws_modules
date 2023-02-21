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
      compute_arn             = var.ecs_cluster_arn
      cron_expression         = var.cron_expression
      iam_role_arn_start_task = var.iam_data.iam_role_arn_ecs_start_task
      definition_arn          = local.task_definition_arn_latest
    }
  }
  std_map = var.std_map
}
