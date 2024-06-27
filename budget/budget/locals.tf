module "name_map" {
  source                          = "../../name_map"
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_map                        = local.l0_map
  std_map                         = var.std_map
}

locals {
  l0_map = {
    for k, v in var.budget_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      account_id                           = v.account_id == null ? var.budget_account_id_default == null ? var.std_map.aws_account_id : var.budget_account_id_default : v.account_id
      auto_adjustment_map                  = v.auto_adjustment_map == null ? var.budget_auto_adjustment_map_default : v.auto_adjustment_map
      budget_type                          = v.budget_type == null ? var.budget_type_default : v.budget_type
      cost_filter_list_map                 = v.cost_filter_list_map == null ? var.budget_cost_filter_list_map_default : v.cost_filter_list_map
      cost_type_include_credit             = v.cost_type_include_credit == null ? var.budget_cost_type_include_credit_default : v.cost_type_include_credit
      cost_type_include_discount           = v.cost_type_include_discount == null ? var.budget_cost_type_include_discount_default : v.cost_type_include_discount
      cost_type_include_other_subscription = v.cost_type_include_other_subscription == null ? var.budget_cost_type_include_other_subscription_default : v.cost_type_include_other_subscription
      cost_type_include_recurring          = v.cost_type_include_recurring == null ? var.budget_cost_type_include_recurring_default : v.cost_type_include_recurring
      cost_type_include_refund             = v.cost_type_include_refund == null ? var.budget_cost_type_include_refund_default : v.cost_type_include_refund
      cost_type_include_subscription       = v.cost_type_include_subscription == null ? var.budget_cost_type_include_subscription_default : v.cost_type_include_subscription
      cost_type_include_support            = v.cost_type_include_support == null ? var.budget_cost_type_include_support_default : v.cost_type_include_support
      cost_type_include_tax                = v.cost_type_include_tax == null ? var.budget_cost_type_include_tax_default : v.cost_type_include_tax
      cost_type_include_upfront            = v.cost_type_include_upfront == null ? var.budget_cost_type_include_upfront_default : v.cost_type_include_upfront
      cost_type_use_amortized              = v.cost_type_use_amortized == null ? var.budget_cost_type_use_amortized_default : v.cost_type_use_amortized
      cost_type_use_blended                = v.cost_type_use_blended == null ? var.budget_cost_type_use_blended_default : v.cost_type_use_blended
      limit_amount                         = v.limit_amount == null ? var.budget_limit_amount_default : v.limit_amount
      limit_unit                           = v.limit_unit == null ? var.budget_limit_unit_default : v.limit_unit
      notification_map                     = v.notification_map == null ? var.budget_notification_map_default : v.notification_map
      planned_limit_map                    = v.planned_limit_map == null ? var.budget_planned_limit_map_default : v.planned_limit_map
      time_period_end                      = v.time_period_end == null ? var.budget_time_period_end_default : v.time_period_end
      time_period_start                    = v.time_period_start == null ? var.budget_time_period_start_default : v.time_period_start
      time_unit                            = v.time_unit == null ? var.budget_time_unit_default : v.time_unit
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      notification_map = {
        for k_n, v_n in local.l1_map[k].notification_map : k_n => merge(v_n, {
          comparison_operator           = v_n.comparison_operator == null ? var.budget_notification_comparison_operator_default : v_n.comparison_operator
          threshold                     = v_n.threshold == null ? var.budget_notification_threshold_default : v_n.threshold
          threshold_type                = v_n.threshold_type == null ? var.budget_notification_threshold_type_default : v_n.threshold_type
          notification_type             = v_n.notification_type == null ? var.budget_notification_type_default : v_n.notification_type
          subscriber_email_address_list = v_n.subscriber_email_address_list == null ? var.budget_notification_subscriber_email_address_list_default : v_n.subscriber_email_address_list
          subscriber_sns_topic_arn_list = v_n.subscriber_sns_topic_arn_list == null ? var.budget_notification_subscriber_sns_topic_arn_list_default : v_n.subscriber_sns_topic_arn_list
        })
      }
    }
  }
  lx_map = {
    for k, _ in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k])
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
