resource "aws_cloudwatch_event_rule" "this_rule" {
  for_each            = local.lx_map
  name                = each.value.name_effective
  event_bus_name      = each.value.event_bus_name
  event_pattern       = each.value.event_pattern_json
  schedule_expression = each.value.schedule_expression
  state               = each.value.is_enabled ? "ENABLED" : "DISABLED" # TODO: ENABLED_WITH_ALL_CLOUDTRAIL_MANAGEMENT_EVENTS
  tags                = each.value.tags
}

module "dead_letter_queue" {
  source    = "../../../sqs/dead_letter_queue"
  queue_map = local.lx_map
  std_map   = var.std_map
}

resource "aws_cloudwatch_event_target" "this_target" {
  for_each = local.lx_map
  arn      = each.value.target_arn
  dynamic "batch_target" {
    for_each = each.value.batch_targets
    content {
      array_size     = each.value.task_count > 1 ? each.value.task_count : null
      job_attempts   = each.value.retry_attempts > 0 ? each.value.retry_attempts : null
      job_definition = each.value.definition_arn
      job_name       = each.value.name_effective
    }
  }
  dead_letter_config {
    arn = each.value.dead_letter_queue_enabled ? module.dead_letter_queue.data[each.key].queue_arn : null
  }
  dynamic "ecs_target" {
    for_each = each.value.ecs_targets
    content {
      # capacity_provider_strategy - delegate to cluster
      enable_ecs_managed_tags = true
      # enable_execute_command - delegate to task
      # group # TODO
      # launch_type - delegate to task
      network_configuration {
        subnets          = each.value.vpc_subnet_id_list
        security_groups  = each.value.vpc_security_group_id_list
        assign_public_ip = each.value.vpc_segment_route_public
      }
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
    for_each = each.value.has_input_transformer ? { this = {} } : {}
    content {
      input_paths = each.value.input_transformer_path_map
      # jsonencode escapes angle brackets and breaks the template
      input_template = each.value.input_transformer_template_string != null ? each.value.input_transformer_template_string : <<-EOT
      {% raw %}{
        "Parameters" : {%{for k, v in each.value.input_transformer_template_doc}
          "${k}": "${v}",%{endfor}
          "swallow": "comma"
        }
      }{% endraw %}
      EOT
    }
  }
  # kinesis_target # TODO
  # redshift_target # TODO
  # retry_policy # TODO
  role_arn = each.value.iam_role_has_default ? module.trigger_role[each.key].data.iam_role_arn : each.value.iam_role_arn_custom
  rule     = aws_cloudwatch_event_rule.this_rule[each.key].name
  # run_command_targets # TODO
  # sqs_target # TODO
  target_id = each.value.name_effective
}
