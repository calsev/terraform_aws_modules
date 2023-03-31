module "name_map" {
  source   = "../name_map"
  name_map = var.event_map
  std_map  = var.std_map
}

locals {
  event_map = {
    for k, v in var.event_map : k => merge(
      v,
      local.l1_map[k],
      local.l2_map[k],
      local.l3_map[k],
      {
        definition_arn      = v.definition_arn == null ? var.event_definition_arn_default : v.definition_arn
        iam_role_arn_custom = v.iam_role_arn_custom == null ? var.event_iam_role_arn_custom_default : v.iam_role_arn_custom
        target_arn          = v.target_arn == null ? var.event_target_arn_default : v.target_arn
      },
    )
  }
  l1_map = {
    for k, v in var.event_map : k => merge(v, module.name_map.data[k], {
      cron_expression            = v.cron_expression == null ? var.event_cron_expression_default : v.cron_expression
      dead_letter_queue_name     = "${k}-dead-letter"
      event_bus_name             = v.event_bus_name == null ? var.event_bus_name_default : v.event_bus_name
      event_pattern_json         = v.event_pattern_json == null ? var.event_pattern_json_default : jsondecode(v.event_pattern_json)
      iam_role_use_custom        = v.iam_role_use_custom == null ? var.event_iam_role_use_custom_default : v.iam_role_use_custom
      input                      = v.input == null ? var.event_input_default : v.input
      input_path                 = v.input_path == null ? var.event_input_path_default : v.input_path
      input_transformer_path_map = v.input_transformer_path_map == null ? var.event_input_transformer_path_map_default : v.input_transformer_path_map
      input_transformer_template = v.input_transformer_template == null ? var.event_input_transformer_template_default : v.input_transformer_template
      is_enabled                 = v.is_enabled == null ? var.event_is_enabled_default : v.is_enabled
      retry_attempts             = v.retry_attempts == null ? var.event_retry_attempts_default : v.retry_attempts
      target_service             = v.target_service == null ? var.event_target_service_default : v.target_service
      task_count                 = v.task_count == null ? var.event_task_count_default : v.task_count
    })
  }
  l2_map = {
    for k, v in var.event_map : k => {
      batch_targets  = local.l1_map[k].target_service == "batch" ? { this = {} } : {}
      ecs_targets    = local.l1_map[k].target_service == "ecs" ? { this = {} } : {}
      event_bus_name = local.l1_map[k].cron_expression == null && local.l1_map[k].event_pattern_json == null ? null : local.l1_map[k].event_bus_name
      event_pattern  = local.l1_map[k].event_pattern_json == null ? null : jsondecode(local.l1_map[k].event_pattern_json)
      input_transformer_template_default = local.l1_map[k].input_transformer_path_map == null ? null : {
        for k_input, _ in local.l1_map[k].input_transformer_path_map : k_input => "<${k_input}>"
      }
      target_is_log = local.l1_map[k].target_service == "logs"
    }
  }
  l3_map = {
    for k, v in var.event_map : k => {
      dead_letter_queue_enabled  = local.l2_map[k].target_is_log ? false : v.dead_letter_queue_enabled == null ? var.event_dead_letter_queue_enabled_default : v.dead_letter_queue_enabled
      iam_role_has_default       = !local.l1_map[k].iam_role_use_custom && !local.l2_map[k].target_is_log
      input_transformer_template = local.l1_map[k].input_transformer_template == null ? local.l2_map[k].input_transformer_template_default : jsondecode(local.l1_map[k].input_transformer_template)
    }
  }
  output_data = {
    for k, v in local.event_map : k => merge(
      {
        for k1, v1 in v : k1 => v1 if !contains(["event_pattern_json"], k1)
      },
      {
        event_rule_arn    = aws_cloudwatch_event_rule.this_rule[k].arn
        event_target_arn  = aws_cloudwatch_event_target.this_target[k].arn
        dead_letter_queue = v.dead_letter_queue_enabled ? module.dead_letter_queue.data[local.l1_map[k].dead_letter_queue_name] : null
        role              = local.l3_map[k].iam_role_has_default ? module.trigger_role[k].data : null
      }
    )
  }
  queue_map = {
    for k, v in var.event_map : local.l1_map[k].dead_letter_queue_name => {
      is_fifo = false
    } if local.l3_map[k].dead_letter_queue_enabled
  }
  role_map = {
    for k, v in local.event_map : k => v if local.l3_map[k].iam_role_has_default
  }
}
