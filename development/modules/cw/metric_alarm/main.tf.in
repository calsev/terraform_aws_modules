resource "aws_cloudwatch_metric_alarm" "this_alarm" {
  for_each                              = local.lx_map
  actions_enabled                       = each.value.alarm_action_enabled
  alarm_actions                         = each.value.alarm_action_target_arn_list
  alarm_description                     = each.value.alarm_description
  alarm_name                            = each.value.name_effective
  comparison_operator                   = each.value.statistic_comparison_operator
  datapoints_to_alarm                   = each.value.alarm_datapoints_to_trigger
  dimensions                            = each.value.metric_dimension_map
  evaluate_low_sample_count_percentiles = each.value.alarm_percentile_low_sample_evaluation_enabled == null ? null : each.value.alarm_percentile_low_sample_evaluation_enabled ? "evaluate" : "ignore"
  evaluation_periods                    = each.value.statistic_evaluation_period_count
  extended_statistic                    = each.value.statistic_threshold_percentile
  insufficient_data_actions             = each.value.alarm_insufficient_data_action_arn_list
  metric_name                           = each.value.metric_name
  dynamic "metric_query" {
    for_each = each.value.metric_query_map
    content {
      account_id = metric_query.value.aws_account_id
      expression = metric_query.value.mathematical_expression
      id         = metric_query.key
      label      = metric_query.value.label_description
      dynamic "metric" {
        for_each = metric_query.value.mathematical_expression == null ? { this = {} } : {}
        content {
          dimensions  = metric_query.value.metric_dimension_map
          metric_name = metric_query.value.metric_name
          namespace   = metric_query.value.metric_namespace
          period      = metric_query.value.metric_period_seconds
          stat        = metric_query.value.metric_statistic
          unit        = metric_query.value.metric_unit
        }
      }
      period      = metric_query.value.period_seconds
      return_data = metric_query.value.return_this_metric_as_alarm
    }
  }
  namespace           = each.value.metric_namespace
  ok_actions          = each.value.alarm_ok_action_arn_list
  period              = each.value.statistic_evaluation_period_seconds
  statistic           = each.value.statistic_for_metric
  tags                = each.value.tags
  threshold           = each.value.statistic_threshold_value
  threshold_metric_id = each.value.statistic_anomaly_detection_metric_id
  treat_missing_data  = each.value.alarm_missing_data_treatment
  unit                = each.value.metric_unit
}
