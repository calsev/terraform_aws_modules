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
    name_append                          = optional(string)
    name_include_app_fields              = optional(bool)
    name_infix                           = optional(bool)
    name_prefix                          = optional(string)
    name_prepend                         = optional(string)
    name_suffix                          = optional(string)
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

variable "name_append_default" {
  type        = string
  default     = ""
  description = "Appended after key"
}

variable "name_include_app_fields_default" {
  type        = bool
  default     = true
  description = "If true, standard project context will be prefixed to the name. Ignored if not name_infix."
}

variable "name_infix_default" {
  type        = bool
  default     = true
  description = "If true, standard project prefix and resource suffix will be added to the name"
}

variable "name_prefix_default" {
  type        = string
  default     = ""
  description = "Prepended before context prefix"
}

variable "name_prepend_default" {
  type        = string
  default     = ""
  description = "Prepended before key"
}

# tflint-ignore: terraform_unused_declarations
variable "name_regex_allow_list" {
  type        = list(string)
  default     = []
  description = "By default, all punctuation is replaced by -"
}

variable "name_suffix_default" {
  type        = string
  default     = ""
  description = "Appended after context suffix"
}

variable "std_map" {
  type = object({
    access_title_map               = map(string)
    aws_account_id                 = string
    aws_region_name                = string
    config_name                    = string
    env                            = string
    iam_partition                  = string
    name_replace_regex             = string
    resource_name_prefix           = string
    resource_name_suffix           = string
    service_resource_access_action = map(map(map(list(string))))
    tags                           = map(string)
  })
}
