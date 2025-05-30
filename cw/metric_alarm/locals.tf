module "name_map" {
  source                          = "../../name_map"
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

locals {
  l0_map = {
    for k, v in var.alarm_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      alarm_action_enabled                    = v.alarm_action_enabled == null ? var.alarm_action_enabled_default : v.alarm_action_enabled
      alarm_action_target_arn_list            = v.alarm_action_target_arn_list == null ? var.alarm_action_target_arn_list_default : v.alarm_action_target_arn_list
      alarm_action_target_sns_topic_key_list  = v.alarm_action_target_sns_topic_key_list == null ? var.alarm_action_target_sns_topic_key_list_default : v.alarm_action_target_sns_topic_key_list
      alarm_datapoints_to_trigger             = v.alarm_datapoints_to_trigger == null ? var.alarm_datapoints_to_trigger_default : v.alarm_datapoints_to_trigger
      alarm_insufficient_data_action_arn_list = v.alarm_insufficient_data_action_arn_list == null ? var.alarm_insufficient_data_action_arn_list_default : v.alarm_insufficient_data_action_arn_list
      alarm_missing_data_treatment            = v.alarm_missing_data_treatment == null ? var.alarm_missing_data_treatment_default : v.alarm_missing_data_treatment
      alarm_ok_action_arn_list                = v.alarm_ok_action_arn_list == null ? var.alarm_ok_action_arn_list_default : v.alarm_ok_action_arn_list
      metric_dimension_map                    = v.metric_dimension_map == null ? var.alarm_metric_dimension_map_default : v.metric_dimension_map
      metric_name                             = v.metric_name == null ? var.alarm_metric_name_default : v.metric_name
      metric_namespace                        = v.metric_namespace == null ? var.alarm_metric_namespace_default : v.metric_namespace
      metric_query_map                        = v.metric_query_map == null ? var.alarm_metric_query_map_default : v.metric_query_map
      metric_unit                             = v.metric_unit == null ? var.alarm_metric_unit_default : v.metric_unit
      statistic_anomaly_detection_metric_id   = v.statistic_anomaly_detection_metric_id == null ? var.alarm_statistic_anomaly_detection_metric_id_default : v.statistic_anomaly_detection_metric_id
      statistic_comparison_operator           = v.statistic_comparison_operator == null ? var.alarm_statistic_comparison_operator_default : v.statistic_comparison_operator
      statistic_evaluation_period_count       = v.statistic_evaluation_period_count == null ? var.alarm_statistic_evaluation_period_count_default : v.statistic_evaluation_period_count
      statistic_evaluation_period_seconds     = v.statistic_evaluation_period_seconds == null ? var.alarm_statistic_evaluation_period_seconds_default : v.statistic_evaluation_period_seconds
      statistic_for_metric                    = v.statistic_for_metric == null ? var.alarm_statistic_for_metric_default : v.statistic_for_metric
      statistic_threshold_percentile          = v.statistic_threshold_percentile == null ? var.alarm_statistic_threshold_percentile_default : v.statistic_threshold_percentile
      statistic_threshold_value               = v.statistic_threshold_value == null ? var.alarm_statistic_threshold_value_default : v.statistic_threshold_value
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      alarm_action_target_arn_list = concat(local.l1_map[k].alarm_action_target_arn_list, [for key in local.l1_map[k].alarm_action_target_sns_topic_key_list : var.sns_data_map.topic_map[key].topic_arn])
      metric_query_map = {
        for k_m, v_m in local.l1_map[k].metric_query_map : k_m => merge(v_m, {
          aws_account_id              = v_m.aws_account_id == null ? var.alarm_metric_query_aws_account_id_default : v_m.aws_account_id
          label_description           = v_m.label_description == null ? var.alarm_metric_query_label_description_default : v_m.label_description
          mathematical_expression     = v_m.mathematical_expression == null ? var.alarm_metric_query_mathematical_expression_default : v_m.mathematical_expression
          metric_dimension_map        = v_m.metric_dimension_map == null ? var.alarm_metric_query_metric_dimension_map_default : v_m.metric_dimension_map
          metric_name                 = v_m.metric_name == null ? var.alarm_metric_query_metric_name_default : v_m.metric_name
          metric_namespace            = v_m.metric_namespace == null ? var.alarm_metric_query_metric_namespace_default : v_m.metric_namespace
          metric_period_seconds       = v_m.metric_period_seconds == null ? var.alarm_metric_query_metric_period_seconds_default : v_m.metric_period_seconds
          metric_statistic            = v_m.metric_statistic == null ? var.alarm_metric_query_metric_statistic_default : v_m.metric_statistic
          metric_unit                 = v_m.metric_unit == null ? var.alarm_metric_query_metric_unit_default : v_m.metric_unit
          period_seconds              = v_m.period_seconds == null ? var.alarm_metric_query_period_seconds_default : v_m.period_seconds
          return_this_metric_as_alarm = v_m.return_this_metric_as_alarm == null ? var.alarm_metric_query_return_this_metric_as_alarm_default : v_m.return_this_metric_as_alarm
        })
      }
      statistic_is_percentile = local.l1_map[k].statistic_threshold_percentile != null
    }
  }
  l3_map = {
    for k, v in local.l0_map : k => {
      alarm_percentile_low_sample_evaluation_enabled = local.l2_map[k].statistic_is_percentile ? v.alarm_percentile_low_sample_evaluation_enabled == null ? var.alarm_percentile_low_sample_evaluation_enabled_default : v.alarm_percentile_low_sample_evaluation_enabled : null
    }
  }
  lx_map = {
    for k, _ in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k], local.l3_map[k])
  }
  output_data = {
    for k, v in local.lx_map : k => merge(
      {
        for k_attr, v_attr in v : k_attr => v_attr if !contains([], k_attr)
      },
      {
      }
    )
  }
}
