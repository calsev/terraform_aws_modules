variable "instance_map" {
  type = map(object({
    cluster_identifier = string
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
    apply_immediately                = optional(bool)
    auto_minor_version_upgrade       = optional(bool)
    availability_zone_name           = optional(string) # Defaults to an AZ the cluster subnet group spans
    ca_cert_identifier               = optional(string)
    certificate_rotation_restart     = optional(bool)
    copy_tags_to_snapshot            = optional(bool)
    engine                           = optional(string)
    instance_class                   = optional(string)
    maintenance_window_utc           = optional(string)
    name_append                      = optional(string)
    name_include_app_fields          = optional(bool)
    name_infix                       = optional(bool)
    name_prefix                      = optional(string)
    name_prepend                     = optional(string)
    name_suffix                      = optional(string)
    performance_insights_enabled     = optional(bool)
    performance_insights_kms_key_arn = optional(string)
    promotion_tier                   = optional(number)
  }))
}

variable "alert_level_default" {
  type    = string
  default = "general_medium"
}

variable "instance_alarm_map_default" {
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
  default = {
    cpu_utilization = {
      alarm_action_enabled                = null
      alarm_description                   = "Alarm when CPU utilization is high for document database instance %s"
      alarm_name                          = "CPU Usage for %s"
      alert_level                         = null
      metric_name                         = "CPUUtilization"
      metric_namespace                    = "AWS/DocDB"
      statistic_comparison_operator       = "GreaterThanThreshold"
      statistic_evaluation_period_count   = 2
      statistic_evaluation_period_seconds = 300
      statistic_for_metric                = "Average"
      statistic_threshold_percentile      = null
      statistic_threshold_value           = 80
    }
    freeable_memory = {
      alarm_action_enabled                = null
      alarm_description                   = "Alarm when freeable memory is low for document database instance %s"
      alarm_name                          = "Free Memory for %s"
      alert_level                         = null
      metric_name                         = "FreeableMemory"
      metric_namespace                    = "AWS/DocDB"
      statistic_comparison_operator       = "LessThanThreshold"
      statistic_evaluation_period_count   = 3
      statistic_evaluation_period_seconds = 300
      statistic_for_metric                = "Average"
      statistic_threshold_percentile      = null
      statistic_threshold_value           = 1024 * 1024 * 1024 # 1 GiB
    }
  }
}

variable "instance_apply_immediately_default" {
  type    = bool
  default = false
}

variable "instance_auto_minor_version_upgrade_default" {
  type    = bool
  default = true
}

variable "instance_availability_zone_name_default" {
  type    = string
  default = null
}

variable "instance_ca_cert_identifier_default" {
  type    = string
  default = null
}

variable "instance_certificate_rotation_restart_default" {
  type    = bool
  default = null
}

variable "instance_class_default" {
  type    = string
  default = "db.t4g.medium"
}

variable "instance_copy_tags_to_snapshot_default" {
  type    = bool
  default = true
}

variable "instance_engine_default" {
  type    = string
  default = "docdb"
}

variable "instance_maintenance_window_utc_default" {
  type        = string
  default     = "Sun:07:00-Sun:08:00"
  description = "Backup and maintenance windows cannot overlap"
}

variable "instance_performance_insights_enabled_default" {
  type        = bool
  default     = true
  description = "The 7-day retention tier is free"
}

variable "instance_performance_insights_kms_key_arn_default" {
  type    = string
  default = null
}

variable "instance_promotion_tier_default" {
  type    = number
  default = null
  validation {
    condition     = var.instance_promotion_tier_default == null ? true : 0 <= var.instance_promotion_tier_default && var.instance_promotion_tier_default <= 15
    error_message = "Promotion tier must be 0-15"
  }
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
