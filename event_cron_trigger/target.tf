resource "aws_cloudwatch_event_rule" "this_rule" {
  # event_bus_name not supported for schedule expression
  name                = local.resource_name
  schedule_expression = var.cron_expression
  tags                = local.tags
}

resource "aws_cloudwatch_event_target" "this_target" {
  arn = var.compute_arn
  dynamic "batch_target" {
    for_each = length(regexall("arn:${var.std_map.iam_partition}:batch:", var.definition_arn)) > 0 ? { this = {} } : {}
    content {
      job_definition = var.definition_arn
      job_name       = local.resource_name
    }
  }
  dynamic "ecs_target" {
    for_each = length(regexall("arn:${var.std_map.iam_partition}:ecs:", var.definition_arn)) > 0 ? { this = {} } : {}
    content {
      enable_ecs_managed_tags = true
      launch_type             = "EC2"
      propagate_tags          = "TASK_DEFINITION"
      tags                    = local.tags
      task_definition_arn     = var.definition_arn
    }
  }
  # event_bus_name not supported for schedule expression
  role_arn  = var.iam_role_arn_start_task
  rule      = aws_cloudwatch_event_rule.this_rule.name
  target_id = local.resource_name
}
