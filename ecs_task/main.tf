module "this_event_bus" {
  for_each = var.cron_expression == null ? {} : {} # TODO: Other event types
  source   = "../event_bus"

  name    = var.name
  std_map = var.std_map
}

module "this_trigger" {
  for_each = var.cron_expression != null ? { this = {} } : {}
  source   = "../event_cron_trigger"

  compute_arn             = var.ecs_cluster_arn
  cron_expression         = var.cron_expression
  iam_role_arn_start_task = var.iam_role_arn_ecs_start_task
  definition_arn          = local.task_definition_arn_latest
  name                    = var.name
  std_map                 = var.std_map
}
