resource "aws_cloudwatch_event_rule" "this_rule" {
  for_each            = local.event_map
  name                = each.value.resource_name
  is_enabled          = each.value.is_enabled
  event_bus_name      = each.value.event_bus_name
  event_pattern       = each.value.event_pattern == null ? null : jsonencode(each.value.event_pattern)
  schedule_expression = each.value.cron_expression
  tags                = each.value.tags
}

module "dead_letter_queue" {
  source    = "../sqs_queue"
  queue_map = local.queue_map
  std_map   = var.std_map
}

resource "aws_cloudwatch_event_target" "this_target" {
  for_each = local.event_map
  arn      = each.value.target_arn
  dynamic "batch_target" {
    for_each = each.value.batch_targets
    content {
      array_size     = local.batch_array_size_map[each.key]
      job_attempts   = local.batch_retry_attempts_map[each.key]
      job_definition = each.value.definition_arn
      job_name       = each.value.resource_name
    }
  }
  dead_letter_config {
    arn = each.value.dead_letter_queue_enabled ? module.dead_letter_queue.data[local.queue_name_map[each.key]].arn : null
  }
  dynamic "ecs_target" {
    for_each = each.value.ecs_targets
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
      tags                = each.value.tags
      task_definition_arn = each.value.definition_arn
      task_count          = each.value.task_count
    }
  }
  event_bus_name = each.value.event_bus_name
  # http_target # TODO
  input      = each.value.input
  input_path = each.value.input_path
  dynamic "input_transformer" {
    for_each = each.value.input_transformer_template == null ? {} : { this = {} }
    content {
      input_paths = each.value.input_transformer_path_map
      # jsonencode escapes angle brackets and breaks the template
      input_template = <<-EOT
      {
        "Parameters" : {%{for k, v in each.value.input_transformer_template}
          "${k}": "${v}",%{endfor}
          "swallow": "comma"
        }
      }
      EOT
    }
  }
  # kinesis_target # TODO
  # redshift_target # TODO
  # retry_policy # TODO
  role_arn = each.value.iam_role_arn_custom == null ? module.trigger_role[each.key].data.iam_role_arn : each.value.iam_role_arn_custom
  rule     = aws_cloudwatch_event_rule.this_rule[each.key].name
  # run_command_targets # TODO
  # sqs_target # TODO
  target_id = each.value.resource_name
}
