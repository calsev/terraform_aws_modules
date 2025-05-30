resource "aws_budgets_budget" "this_budget" {
  for_each   = local.lx_map
  account_id = each.value.account_id
  dynamic "auto_adjust_data" {
    for_each = each.value.auto_adjustment_map
    content {
      auto_adjust_type = auto_adjust_data.value.auto_adjust_type
      dynamic "historical_options" {
        for_each = {}
        content {
          budget_adjustment_period   = historical_options.value.historical_budget_adjustment_period
          lookback_available_periods = historical_options.value.historical_lookback_available_period_list
        }
      }
      last_auto_adjust_time = auto_adjust_data.value.last_auto_adjust_time
    }
  }
  budget_type = each.value.budget_type
  dynamic "cost_filter" {
    for_each = each.value.cost_filter_list_map
    content {
      name   = cost_filter.key
      values = cost_filter.value
    }
  }
  cost_types {
    include_credit             = each.value.cost_type_include_credit
    include_discount           = each.value.cost_type_include_discount
    include_other_subscription = each.value.cost_type_include_other_subscription
    include_recurring          = each.value.cost_type_include_recurring
    include_refund             = each.value.cost_type_include_refund
    include_subscription       = each.value.cost_type_include_subscription
    include_support            = each.value.cost_type_include_support
    include_tax                = each.value.cost_type_include_tax
    include_upfront            = each.value.cost_type_include_upfront
    use_amortized              = each.value.cost_type_use_amortized
    use_blended                = each.value.cost_type_use_blended
  }
  limit_amount = each.value.limit_amount
  limit_unit   = each.value.limit_unit
  name         = each.value.name_effective
  name_prefix  = null
  dynamic "notification" {
    for_each = each.value.notification_map
    content {
      comparison_operator        = notification.value.comparison_operator
      threshold                  = notification.value.threshold
      threshold_type             = notification.value.threshold_type
      notification_type          = notification.value.notification_type
      subscriber_email_addresses = notification.value.subscriber_email_address_list
      subscriber_sns_topic_arns  = notification.value.subscriber_sns_topic_arn_list
    }
  }
  dynamic "planned_limit" {
    for_each = each.value.planned_limit_map
    content {
      start_time = planned_limit.value.start_time
      amount     = planned_limit.value.limit_amount
      unit       = planned_limit.value.limit_unit
    }
  }
  tags              = each.value.tags
  time_period_end   = each.value.time_period_end
  time_period_start = each.value.time_period_start
  time_unit         = each.value.time_unit
}
