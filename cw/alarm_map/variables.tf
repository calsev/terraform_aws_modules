variable "alarm_map" {
  type = map(object({
    alarm_map = optional(map(object({
      alarm_action_enabled                = optional(bool)
      alarm_description                   = string # Human-friendly description
      alarm_name                          = string # Human-friendly name
      alert_level                         = optional(string)
      metric_name                         = optional(string)
      metric_namespace                    = optional(string)
      statistic_comparison_operator       = optional(string)
      statistic_evaluation_period_count   = optional(number)
      statistic_evaluation_period_seconds = optional(number)
      statistic_for_metric                = optional(string)
      statistic_threshold_percentile      = optional(number)
      statistic_threshold_value           = optional(number)
    })))
  }))
}

variable "alarm_map_default" {
  type = map(object({
    alarm_action_enabled                = optional(bool)
    alarm_description                   = string # Human-friendly description
    alarm_name                          = string # Human-friendly name
    alert_level                         = optional(string)
    metric_name                         = optional(string)
    metric_namespace                    = optional(string)
    statistic_comparison_operator       = optional(string)
    statistic_evaluation_period_count   = optional(number)
    statistic_evaluation_period_seconds = optional(number)
    statistic_for_metric                = optional(string)
    statistic_threshold_percentile      = optional(number)
    statistic_threshold_value           = optional(number)
  }))
}

variable "alert_level_default" {
  type    = string
  default = "general_medium"
}

variable "monitor_data" {
  type = object({
    alert = object({
      topic_map = map(object({
        policy_map = map(object({
          iam_policy_arn = string
        }))
        topic_arn = string
      }))
    })
    ecs_ssm_param_map = object({
      cpu = object({
        policy_map = map(object({
          iam_policy_arn = string
        }))
        name_effective = string
      })
      gpu = object({
        policy_map = map(object({
          iam_policy_arn = string
        }))
        name_effective = string
      })
    })
  })
}

variable "name_map" {
  type = map(object({
    name_effective = string
  }))
}
