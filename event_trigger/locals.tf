module "name_map" {
  source   = "../name_map"
  name_map = var.event_map
  std_map  = var.std_map
}

module "vpc_map" {
  source                              = "../vpc_id_map"
  vpc_az_key_list_default             = var.vpc_az_key_list_default
  vpc_key_default                     = var.vpc_key_default
  vpc_map                             = var.event_map
  vpc_security_group_key_list_default = var.vpc_security_group_key_list_default
  vpc_segment_key_default             = var.vpc_segment_key_default
  vpc_data_map                        = var.vpc_data_map
}

locals {
  event_map = {
    for k, v in var.event_map : k => merge(
      v,
      local.l1_map[k],
      local.l2_map[k],
      local.l3_map[k],
      local.l4_map[k],
    )
  }
  l1_map = {
    for k, v in var.event_map : k => merge(v, module.name_map.data[k], module.vpc_map.data[k], {
      schedule_expression               = v.schedule_expression == null ? var.event_schedule_expression_default : v.schedule_expression
      dead_letter_queue_name            = "${k}-dead-letter"
      definition_arn                    = v.definition_arn == null ? var.event_definition_arn_default : v.definition_arn
      event_bus_name                    = v.event_bus_name == null ? var.event_bus_name_default : v.event_bus_name
      event_pattern_json                = v.event_pattern_json == null ? var.event_pattern_json_default : v.event_pattern_json
      iam_role_arn_custom               = v.iam_role_arn_custom == null ? var.event_iam_role_arn_custom_default : v.iam_role_arn_custom
      iam_role_use_custom               = v.iam_role_use_custom == null ? var.event_iam_role_use_custom_default : v.iam_role_use_custom
      input                             = v.input == null ? var.event_input_default : v.input
      input_path                        = v.input_path == null ? var.event_input_path_default : v.input_path
      input_transformer_path_map        = v.input_transformer_path_map == null ? var.event_input_transformer_path_map_default : v.input_transformer_path_map
      input_transformer_template_json   = v.input_transformer_template_json == null ? var.event_input_transformer_template_json_default : v.input_transformer_template_json
      input_transformer_template_string = v.input_transformer_template_string == null ? var.event_input_transformer_template_string_default : v.input_transformer_template_string
      is_enabled                        = v.is_enabled == null ? var.event_is_enabled_default : v.is_enabled
      retry_attempts                    = v.retry_attempts == null ? var.event_retry_attempts_default : v.retry_attempts
      target_arn                        = v.target_arn == null ? var.event_target_arn_default : v.target_arn
      target_service                    = v.target_service == null ? var.event_target_service_default : v.target_service
      task_count                        = v.task_count == null ? var.event_task_count_default : v.task_count
    })
  }
  l2_map = {
    for k, v in var.event_map : k => {
      batch_targets         = local.l1_map[k].target_service == "batch" ? { this = {} } : {}
      ecs_targets           = local.l1_map[k].target_service == "ecs" ? { this = {} } : {}
      event_bus_name        = local.l1_map[k].schedule_expression == null && local.l1_map[k].event_pattern_json == null ? null : local.l1_map[k].event_bus_name
      event_pattern         = local.l1_map[k].event_pattern_json == null ? null : jsondecode(local.l1_map[k].event_pattern_json)
      iam_policy_arn_target = v.iam_policy_arn_target == null ? var.event_iam_policy_arn_target_default : v.iam_policy_arn_target
      input_transformer_template_doc_default = local.l1_map[k].input_transformer_path_map == null ? null : {
        for k_input, _ in local.l1_map[k].input_transformer_path_map : k_input => "<${k_input}>"
      }
      target_is_bus = local.l1_map[k].target_service == "events"
      target_is_log = local.l1_map[k].target_service == "logs"
      target_is_sns = local.l1_map[k].target_service == "sns"
    }
  }
  l3_map = {
    for k, v in var.event_map : k => {
      dead_letter_queue_enabled      = local.l2_map[k].target_is_bus ? false : local.l2_map[k].target_is_log ? false : local.l2_map[k].target_is_sns ? false : v.dead_letter_queue_enabled == null ? var.event_dead_letter_queue_enabled_default : v.dead_letter_queue_enabled
      iam_role_has_default           = !local.l1_map[k].iam_role_use_custom && !local.l2_map[k].target_is_log && !local.l2_map[k].target_is_sns # Log and Topic targets do not support identity-based roles; handle with resource policies
      input_transformer_template_doc = local.l1_map[k].input_transformer_template_json == null ? local.l2_map[k].input_transformer_template_doc_default : jsondecode(local.l1_map[k].input_transformer_template_json)
    }
  }
  l4_map = {
    for k, v in var.event_map : k => {
      has_input_transformer = local.l1_map[k].input_transformer_template_string != null || local.l3_map[k].input_transformer_template_doc != null
    }
  }
  output_data = {
    for k, v in local.event_map : k => merge(
      {
        for k1, v1 in v : k1 => v1 if !contains(["event_pattern_json", "input_transformer_template_json"], k1)
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
    for k, v in local.event_map : k => v if v.iam_role_has_default
  }
}
