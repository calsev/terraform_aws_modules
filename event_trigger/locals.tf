locals {
  batch_array_size_map = {
    for k, v in var.event_map : k => local.event_map[k].task_count > 1 ? local.event_map[k].task_count : null
  }
  batch_retry_attempts_map = {
    for k, v in var.event_map : k => local.event_map[k].retry_attempts > 0 ? local.event_map[k].retry_attempts : null
  }
  cron_expression_map = {
    for k, v in var.event_map : k => v.cron_expression == null ? var.event_cron_expression_default : v.cron_expression
  }
  definition_arn_map = {
    for k, v in var.event_map : k => v.definition_arn == null ? var.event_definition_arn_default : v.definition_arn
  }
  event_map = {
    for k, v in var.event_map : k => {
      batch_targets              = local.definition_arn_map[k] == null ? {} : length(regexall("arn:${var.std_map.iam_partition}:batch:", local.definition_arn_map[k])) > 0 ? { this = {} } : {}
      cron_expression            = local.cron_expression_map[k]
      dead_letter_queue_enabled  = v.dead_letter_queue_enabled == null ? var.event_dead_letter_queue_enabled_default : v.dead_letter_queue_enabled
      definition_arn             = local.definition_arn_map[k]
      ecs_targets                = local.definition_arn_map[k] == null ? {} : length(regexall("arn:${var.std_map.iam_partition}:ecs:", local.definition_arn_map[k])) > 0 ? { this = {} } : {}
      event_bus_name             = local.cron_expression_map[k] == null && local.event_pattern_json_map[k] == null ? null : local.event_bus_name_map[k]
      event_pattern              = local.event_pattern_json_map[k] == null ? null : jsondecode(local.event_pattern_json_map[k])
      iam_role_arn_start_task    = v.iam_role_arn_start_task == null ? var.event_iam_role_arn_start_task_default : v.iam_role_arn_start_task
      input                      = v.input == null ? var.event_input_default : v.input
      input_path                 = v.input_path == null ? var.event_input_path_default : v.input_path
      input_transformer_path_map = local.input_transformer_path_map[k]
      input_transformer_template = local.input_transformer_template_map[k] == null ? local.input_transformer_template_default_map[k] : jsondecode(local.input_transformer_template_map[k])
      is_enabled                 = v.is_enabled == null ? var.event_is_enabled_default : v.is_enabled
      retry_attempts             = v.retry_attempts == null ? var.event_retry_attempts_default : v.retry_attempts
      resource_name              = local.resource_name_map[k]
      tags = merge(
        var.std_map.tags,
        {
          Name = local.resource_name_map[k]
        }
      )
      target_arn = v.target_arn == null ? var.event_target_arn_default : v.target_arn
      task_count = v.task_count == null ? var.event_task_count_default : v.task_count
    }
  }
  event_bus_name_map = {
    for k, v in var.event_map : k => v.event_bus_name == null ? var.event_bus_name_default : v.event_bus_name
  }
  event_pattern_json_map = {
    for k, v in var.event_map : k => v.event_pattern_json == null ? var.event_pattern_json_default : v.event_pattern_json
  }
  input_transformer_path_map = {
    for k, v in var.event_map : k => v.input_transformer_path_map == null ? var.event_input_transformer_path_map_default : v.input_transformer_path_map
  }
  input_transformer_template_default_map = {
    for k, v in var.event_map : k => local.input_transformer_path_map[k] == null ? null : {
      for k_input, _ in local.input_transformer_path_map[k] : k_input => "<${k_input}>"
    }
  }
  input_transformer_template_map = {
    for k, v in var.event_map : k => v.input_transformer_template == null ? var.event_input_transformer_template_default : v.input_transformer_template
  }
  output_data = {
    for k, v in local.event_map : k => merge(v, {
      event_rule_arn    = aws_cloudwatch_event_rule.this_rule[k].arn
      event_trigger_arn = aws_cloudwatch_event_target.this_target[k].arn
      dead_letter       = v.dead_letter_queue_enabled ? module.dead_letter_queue.data[local.queue_name_map[k]] : null
    })
  }
  queue_map = {
    for k, v in local.queue_name_map : local.queue_name_map[k] => {
      is_fifo = false
    }
  }
  queue_name_map = {
    for k, v in local.event_map : k => "${k}-dead-letter" if v.dead_letter_queue_enabled
  }
  resource_name_map = {
    for k, v in var.event_map : k => "${var.std_map.resource_name_prefix}${replace(k, "/_/", "-")}${var.std_map.resource_name_suffix}"
  }
}
