variable "alarm_map" {
  type = map(object({
    alarm_action_enabled                           = optional(bool)
    alarm_action_target_arn_list                   = optional(list(string))
    alarm_action_target_sns_topic_key_list         = optional(list(string))
    alarm_datapoints_to_trigger                    = optional(number)
    alarm_description                              = string # Human-friendly description
    alarm_insufficient_data_action_arn_list        = optional(list(string))
    alarm_missing_data_treatment                   = optional(string)
    alarm_name                                     = string # Human-friendly name
    alarm_ok_action_arn_list                       = optional(list(string))
    alarm_percentile_low_sample_evaluation_enabled = optional(bool)
    metric_dimension_map                           = optional(map(string))
    metric_name                                    = optional(string)
    metric_namespace                               = optional(string)
    metric_query_map = optional(map(object({
      aws_account_id              = optional(string)
      label_description           = optional(string)
      mathematical_expression     = optional(string)
      metric_dimension_map        = optional(map(string))
      metric_name                 = optional(string)
      metric_namespace            = optional(string)
      metric_period_seconds       = optional(number)
      metric_statistic            = optional(string)
      metric_unit                 = optional(string)
      period_seconds              = optional(number)
      return_this_metric_as_alarm = optional(bool)
    })))
    metric_unit                           = optional(string)
    name_append                           = optional(bool)
    name_include_app_fields               = optional(bool)
    name_infix                            = optional(bool)
    name_prepend                          = optional(bool)
    statistic_anomaly_detection_metric_id = optional(string)
    statistic_comparison_operator         = optional(string)
    statistic_evaluation_period_count     = optional(number)
    statistic_evaluation_period_seconds   = optional(number)
    statistic_for_metric                  = optional(string)
    statistic_threshold_percentile        = optional(number)
    statistic_threshold_value             = optional(number)
  }))
}

variable "alarm_action_enabled_default" {
  type    = bool
  default = true
}

variable "alarm_action_target_arn_list_default" {
  type        = list(string)
  default     = []
  description = "Other action types. SNS is handled by alarm_action_sns_topic_key_list"
}

variable "alarm_action_target_sns_topic_key_list_default" {
  type    = list(string)
  default = []
}

variable "alarm_datapoints_to_trigger_default" {
  type    = number
  default = 1
}

variable "alarm_insufficient_data_action_arn_list_default" {
  type    = list(string)
  default = []
}

variable "alarm_missing_data_treatment_default" {
  type    = string
  default = "missing"
  validation {
    condition     = contains(["breaching", "ignore", "missing", "notBreaching"], var.alarm_missing_data_treatment_default)
    error_message = "Invalid alarm missing data treatment"
  }
}

variable "alarm_ok_action_arn_list_default" {
  type    = list(string)
  default = []
}

variable "alarm_percentile_low_sample_evaluation_enabled_default" {
  type        = bool
  default     = false
  description = "Ignored unless statistic is percentile"
}

variable "alarm_metric_dimension_map_default" {
  type        = map(string)
  default     = {}
  description = "Map of dimension to value, e.g. InstanceId = \"i-abc123\""
}

variable "alarm_metric_name_default" {
  type    = string
  default = null
}

variable "alarm_metric_namespace_default" {
  type        = string
  default     = null
  description = "See https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/aws-services-cloudwatch-metrics.html"
}

variable "alarm_metric_query_map_default" {
  type = map(object({
    aws_account_id              = optional(string)
    label_description           = optional(string)
    mathematical_expression     = optional(string)
    metric_dimension_map        = optional(map(string))
    metric_name                 = optional(string)
    metric_namespace            = optional(string)
    metric_period_seconds       = optional(number)
    metric_statistic            = optional(string)
    metric_unit                 = optional(string)
    period_seconds              = optional(number)
    return_this_metric_as_alarm = optional(bool)
  }))
  default     = {}
  description = "Map of ID to attributes"
}

variable "alarm_metric_query_aws_account_id_default" {
  type        = string
  default     = null
  description = "Defaults to aws_account_id from std_map"
}

variable "alarm_metric_query_label_description_default" {
  type        = string
  default     = null
  description = "Human-friendly label"
}

variable "alarm_metric_query_mathematical_expression_default" {
  type        = string
  default     = null
  description = "Either a mathematical_expression or metric must be specified"
}

variable "alarm_metric_query_metric_dimension_map_default" {
  type        = map(string)
  default     = {}
  description = "Map of dimension to value, e.g. InstanceId = \"i-abc123\""
}

variable "alarm_metric_query_metric_name_default" {
  type    = string
  default = null
}

variable "alarm_metric_query_metric_namespace_default" {
  type    = string
  default = null
}

variable "alarm_metric_query_metric_period_seconds_default" {
  type        = number
  default     = 60
  description = "Granularity of data returned"
  validation {
    condition     = var.alarm_metric_query_metric_period_seconds_default == null ? true : contains([1, 5, 10, 30], var.alarm_metric_query_metric_period_seconds_default) || var.alarm_metric_query_metric_period_seconds_default % 60 == 0
    error_message = "Invalid period"
  }
}

variable "alarm_metric_query_metric_statistic_default" {
  type        = string
  default     = null
  description = "See https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Statistics-definitions.html"
}

variable "alarm_metric_query_metric_unit_default" {
  type        = string
  default     = null
  description = "See https://docs.aws.amazon.com/AmazonCloudWatch/latest/APIReference/API_MetricAlarm.html"
}

variable "alarm_metric_query_period_seconds_default" {
  type        = number
  default     = 60
  description = "Granularity of data returned"
  validation {
    condition     = var.alarm_metric_query_period_seconds_default == null ? true : contains([1, 5, 10, 30], var.alarm_metric_query_period_seconds_default) || var.alarm_metric_query_period_seconds_default % 60 == 0
    error_message = "Invalid period"
  }
}

variable "alarm_metric_query_return_this_metric_as_alarm_default" {
  type        = bool
  default     = false
  description = "Exacly one metric query must be returned as the alarm"
}

variable "alarm_metric_unit_default" {
  type        = string
  default     = null
  description = "See https://docs.aws.amazon.com/AmazonCloudWatch/latest/APIReference/API_MetricAlarm.html"
}

variable "alarm_statistic_anomaly_detection_metric_id_default" {
  type        = string
  default     = null
  description = "If this is an alarm based on an anomaly detection model, make this value match the ID of the ANOMALY_DETECTION_BAND function."
}

variable "alarm_statistic_comparison_operator_default" {
  type    = string
  default = null
  validation {
    condition = var.alarm_statistic_comparison_operator_default == null ? true : contains(
      [
        "GreaterThanOrEqualToThreshold",
        "GreaterThanThreshold",
        "LessThanOrEqualToThreshold",
        "LessThanThreshold",
        # Below for anomaly detection
        "GreaterThanUpperThreshold",
        "LessThanLowerOrGreaterThanUpperThreshold",
        "LessThanLowerThreshold",
      ],
      var.alarm_statistic_comparison_operator_default
    )
    error_message = "Invalid statistic comparison operator"
  }
}

variable "alarm_statistic_evaluation_period_count_default" {
  type    = number
  default = 1
}

variable "alarm_statistic_evaluation_period_seconds_default" {
  type    = number
  default = 60
  validation {
    condition     = var.alarm_statistic_evaluation_period_seconds_default == null ? true : contains([10, 30], var.alarm_statistic_evaluation_period_seconds_default) || var.alarm_statistic_evaluation_period_seconds_default % 60 == 0
    error_message = "Invalid period"
  }
}

variable "alarm_statistic_for_metric_default" {
  type    = string
  default = null
  validation {
    condition     = var.alarm_statistic_for_metric_default == null ? true : contains(["Average", "Maximum", "Minimum", "SampleCount", "Sum"], var.alarm_statistic_for_metric_default)
    error_message = "Invalid statistic for metric"
  }
}

variable "alarm_statistic_threshold_percentile_default" {
  type    = number
  default = null
  validation {
    condition     = var.alarm_statistic_threshold_percentile_default == null ? true : 0 <= var.alarm_statistic_threshold_percentile_default && var.alarm_statistic_threshold_percentile_default <= 100
    error_message = "Invalid statistic threshold percentile"
  }
}

variable "alarm_statistic_threshold_value_default" {
  type    = number
  default = null
}

variable "name_append_default" {
  type        = string
  default     = ""
  description = "Appended after key"
}

variable "name_include_app_fields_default" {
  type        = bool
  default     = true
  description = "If true, the Terraform project context will be included in the name"
}

variable "name_infix_default" {
  type    = bool
  default = true
}

variable "name_prepend_default" {
  type        = string
  default     = ""
  description = "Prepended before key"
}

variable "sns_data_map" {
  type = object({
    topic_map = map(object({
      topic_arn = string
    }))
  })
  default     = null
  description = "Must be provided if any alarm specifies a topic key"
}

variable "std_map" {
  type = object({
    name_replace_regex   = string
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}
