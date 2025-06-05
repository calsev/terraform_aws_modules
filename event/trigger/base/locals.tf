module "name_map" {
  source                          = "../../../name_map"
  name_append_default             = var.name_append_default
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_map                        = local.l0_map
  name_prefix_default             = var.name_prefix_default
  name_prepend_default            = var.name_prepend_default
  name_regex_allow_list           = var.name_regex_allow_list
  name_suffix_default             = var.name_suffix_default
  std_map                         = var.std_map
}

module "vpc_map" {
  source                              = "../../../vpc/id_map"
  vpc_az_key_list_default             = var.vpc_az_key_list_default
  vpc_data_map                        = var.vpc_data_map
  vpc_key_default                     = var.vpc_key_default
  vpc_map                             = local.l0_map
  vpc_security_group_key_list_default = var.vpc_security_group_key_list_default
  vpc_segment_key_default             = var.vpc_segment_key_default
}

locals {
  create_role_map = {
    for k, v in local.lx_map : k => v if v.iam_role_has_default
  }
  l0_map = {
    for k, v in var.event_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], module.vpc_map.data[k], {
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
      schedule_expression               = v.schedule_expression == null ? var.event_schedule_expression_default : v.schedule_expression
      target_arn                        = v.target_arn == null ? var.event_target_arn_default : v.target_arn
      target_service                    = v.target_service == null ? var.event_target_service_default : v.target_service
      task_count                        = v.task_count == null ? var.event_task_count_default : v.task_count
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      batch_targets     = local.l1_map[k].target_service == "batch" ? { this = {} } : {}
      ecs_targets       = local.l1_map[k].target_service == "ecs" ? { this = {} } : {}
      event_bus_name    = local.l1_map[k].schedule_expression == null && local.l1_map[k].event_pattern_json == null ? null : local.l1_map[k].event_bus_name
      event_pattern_doc = local.l1_map[k].event_pattern_json == null ? null : jsondecode(local.l1_map[k].event_pattern_json)
      input_transformer_template_doc_default = local.l1_map[k].input_transformer_path_map == null ? null : {
        for k_input, _ in local.l1_map[k].input_transformer_path_map : k_input => "<${k_input}>"
      }
      target_is_bus = local.l1_map[k].target_service == "events"
      target_is_log = local.l1_map[k].target_service == "logs"
      target_is_sns = local.l1_map[k].target_service == "sns"
    }
  }
  l3_map = {
    for k, v in local.l0_map : k => {
      dead_letter_queue_enabled      = local.l2_map[k].target_is_bus ? false : local.l2_map[k].target_is_log ? false : local.l2_map[k].target_is_sns ? false : v.dead_letter_queue_enabled == null ? var.event_dead_letter_queue_enabled_default : v.dead_letter_queue_enabled
      iam_role_has_default           = !local.l1_map[k].iam_role_use_custom && !local.l2_map[k].target_is_log && !local.l2_map[k].target_is_sns # Log and Topic targets do not support identity-based roles; handle with resource policies
      input_transformer_template_doc = local.l1_map[k].input_transformer_template_json == null ? local.l2_map[k].input_transformer_template_doc_default : jsondecode(local.l1_map[k].input_transformer_template_json)
    }
  }
  l4_map = {
    for k, v in local.l0_map : k => {
      has_input_transformer = local.l1_map[k].input_transformer_template_string != null || local.l3_map[k].input_transformer_template_doc != null
    }
  }
  lx_map = {
    for k, _ in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k], local.l3_map[k], local.l4_map[k])
  }
  output_data = {
    for k, v in local.lx_map : k => merge(
      {
        for k_attr, v_attr in v : k_attr => v_attr if !contains(["event_pattern_json", "input_transformer_template_json"], k_attr)
      },
      {
        event_rule_arn    = aws_cloudwatch_event_rule.this_rule[k].arn
        event_target_arn  = aws_cloudwatch_event_target.this_target[k].arn
        dead_letter_queue = module.dead_letter_queue.data[k]
        role              = local.l3_map[k].iam_role_has_default ? module.trigger_role[k].data : null
      }
    )
  }
}
