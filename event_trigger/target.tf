resource "aws_cloudwatch_event_rule" "this_rule" {
  name                = local.resource_name
  is_enabled          = var.is_enabled
  event_bus_name      = local.event_bus_name
  event_pattern       = var.event_pattern_json
  schedule_expression = var.cron_expression
  tags                = local.tags
}

resource "aws_cloudwatch_event_target" "this_target" {
  arn = var.compute_arn
  dynamic "batch_target" {
    for_each = length(regexall("arn:${var.std_map.iam_partition}:batch:", var.definition_arn)) > 0 ? { this = {} } : {}
    content {
      array_size     = local.batch_array_size
      job_attempts   = local.batch_retry_attempts
      job_definition = var.definition_arn
      job_name       = local.resource_name
    }
  }
  dead_letter_config {
    arn = var.sqs_queue_arn_dead_letter
  }
  dynamic "ecs_target" {
    for_each = length(regexall("arn:${var.std_map.iam_partition}:ecs:", var.definition_arn)) > 0 ? { this = {} } : {}
    content {
      # capacity_provider_strategy - delegate to cluster
      enable_ecs_managed_tags = true
      # enable_execute_command - delegate to task
      # group # TODO
      # launch_type - delegate to task
      # network_configuration - delegate to task
      # placement_constraint - delegate to task
      # platform_version # TODO: For fargate
      propagate_tags      = "TASK_DEFINITION"
      tags                = local.tags
      task_definition_arn = var.definition_arn
      task_count          = var.task_count
    }
  }
  event_bus_name = local.event_bus_name
  # http_target # TODO
  # input # TODO
  # input_path # TODO
  # input_transformer # TODO
  # kinesis_target # TODO
  # redshift_target # TODO
  # retry_policy # TODO
  role_arn = var.iam_role_arn_start_task
  rule     = aws_cloudwatch_event_rule.this_rule.name
  # run_command_targets # TODO
  # sqs_target # TODO
  target_id = local.resource_name
}
