variable "budget_map" {
  type = map(object({
    account_id = optional(string)
    auto_adjustment_map = optional(map(object({
      auto_adjust_type                          = optional(string)
      historical_budget_adjustment_period       = optional(string)
      historical_lookback_available_period_list = optional(list(string))
      last_auto_adjust_time                     = optional(string)
    })))
    budget_type                          = optional(string)
    cost_filter_list_map                 = optional(map(list(string)))
    cost_type_include_credit             = optional(bool)
    cost_type_include_discount           = optional(bool)
    cost_type_include_other_subscription = optional(bool)
    cost_type_include_recurring          = optional(bool)
    cost_type_include_refund             = optional(bool)
    cost_type_include_subscription       = optional(bool)
    cost_type_include_support            = optional(bool)
    cost_type_include_tax                = optional(bool)
    cost_type_include_upfront            = optional(bool)
    cost_type_use_amortized              = optional(bool)
    cost_type_use_blended                = optional(bool)
    limit_amount                         = optional(number)
    limit_unit                           = optional(string)
    {{ name.var_item() }}
    notification_map = optional(map(object({
      comparison_operator           = optional(string)
      threshold                     = optional(number)
      threshold_type                = optional(string)
      notification_type             = optional(string)
      subscriber_email_address_list = optional(list(string))
      subscriber_sns_topic_arn_list = optional(list(string))
    })))
    planned_limit_map = optional(map(object({
      start_time   = optional(string)
      limit_amount = optional(number)
      limit_unit   = optional(string)
    })))
    time_period_end   = optional(string)
    time_period_start = optional(string)
    time_unit         = optional(string)
  }))
}

variable "budget_account_id_default" {
  type        = string
  default     = null
  description = "Defaults to account ID for std_map"
}

variable "budget_auto_adjustment_map_default" {
  type = map(object({
    auto_adjust_type                          = optional(string)
    historical_budget_adjustment_period       = optional(string)
    historical_lookback_available_period_list = optional(list(string))
    last_auto_adjust_time                     = optional(string)
  }))
  default = {}
}

variable "budget_type_default" {
  type    = string
  default = "COST"
}

variable "budget_cost_filter_list_map_default" {
  type    = map(list(string))
  default = {}
}

variable "budget_cost_type_include_credit_default" {
  type    = bool
  default = true
}

variable "budget_cost_type_include_discount_default" {
  type    = bool
  default = true
}

variable "budget_cost_type_include_other_subscription_default" {
  type    = bool
  default = true
}

variable "budget_cost_type_include_recurring_default" {
  type    = bool
  default = true
}

variable "budget_cost_type_include_refund_default" {
  type    = bool
  default = true
}

variable "budget_cost_type_include_subscription_default" {
  type    = bool
  default = true
}

variable "budget_cost_type_include_support_default" {
  type    = bool
  default = true
}

variable "budget_cost_type_include_tax_default" {
  type    = bool
  default = true
}

variable "budget_cost_type_include_upfront_default" {
  type    = bool
  default = true
}

variable "budget_cost_type_use_amortized_default" {
  type    = bool
  default = true
}

variable "budget_cost_type_use_blended_default" {
  type        = bool
  default     = false
  description = "Conflicts with include_discount and use_amortized"
}

variable "budget_limit_amount_default" {
  type    = number
  default = null
}

variable "budget_limit_unit_default" {
  type    = string
  default = "USD"
}

variable "budget_notification_map_default" {
  type = map(object({
    comparison_operator           = optional(string)
    threshold                     = optional(number)
    threshold_type                = optional(string)
    notification_type             = optional(string)
    subscriber_email_address_list = optional(list(string))
    subscriber_sns_topic_arn_list = optional(list(string))
  }))
  default = {
    forecast_over_budget = {
    }
  }
}

variable "budget_notification_comparison_operator_default" {
  type    = string
  default = "GREATER_THAN"
  validation {
    condition     = contains(["EQUAL_TO", "GREATER_THAN", "LESS_THAN"], var.budget_notification_comparison_operator_default)
    error_message = "Invalid comparison operator"
  }
}

variable "budget_notification_threshold_default" {
  type    = number
  default = 100
}

variable "budget_notification_threshold_type_default" {
  type    = string
  default = "PERCENTAGE"
  validation {
    condition     = contains(["ABSOLUTE_VALUE", "PERCENTAGE"], var.budget_notification_threshold_type_default)
    error_message = "Invalid threshold type"
  }
}

variable "budget_notification_type_default" {
  type    = string
  default = "FORECASTED"
  validation {
    condition     = contains(["ACTUAL", "FORECASTED"], var.budget_notification_type_default)
    error_message = "Invalid notification type"
  }
}

variable "budget_notification_subscriber_email_address_list_default" {
  type    = list(string)
  default = []
}

variable "budget_notification_subscriber_sns_topic_arn_list_default" {
  type    = list(string)
  default = []
}

variable "budget_planned_limit_map_default" {
  type = map(object({
    start_time   = optional(string)
    limit_amount = optional(number)
    limit_unit   = optional(string)
  }))
  default = {}
}

variable "budget_time_period_end_default" {
  type    = string
  default = null
}

variable "budget_time_period_start_default" {
  type    = string
  default = null
}

variable "budget_time_unit_default" {
  type    = string
  default = "MONTHLY"
  validation {
    condition     = contains(["ANNUALLY", "DAILY", "MONTHLY", "QUARTERLY"], var.budget_time_unit_default)
    error_message = "Invalid time unit"
  }
}

{{ name.var() }}

{{ std.map() }}
