variable "cluster_map" {
  type = map(object({
    allow_major_version_upgrade = optional(bool)
    apply_immediately           = optional(bool)
    backup_retention_period_day = optional(number)
    backup_window_utc           = optional(string)
    cloudwatch_log_export_list  = optional(list(string))
    deletion_protection         = optional(bool)
    engine                      = optional(string)
    engine_version              = optional(string) # Changes ignored
    final_snapshot_enabled      = optional(bool)
    final_snapshot_identifier   = optional(string) # Defaults to name_effective
    instance_map = optional(map(object({
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
    })))
    kms_key_id                  = optional(string)
    maintenance_window_utc      = optional(string)
    name_append                 = optional(string)
    name_include_app_fields     = optional(bool)
    name_infix                  = optional(bool)
    name_prefix                 = optional(string)
    name_prepend                = optional(string)
    name_suffix                 = optional(string)
    network_type                = optional(string)
    parameter_group_name        = optional(string) # A cluster parameter group name, e.g. default.docdb8.0
    password_secret_name_append = optional(string)
    port                        = optional(number)
    secret_is_param             = optional(bool)
    snapshot_identifier         = optional(string)
    storage_encrypted           = optional(bool)
    storage_type                = optional(string)
    subnet_group_name           = optional(string) # A DB subnet group name; RDS subnet groups serve DocumentDB
    username                    = optional(string)
    vpc_key                     = optional(string)
    vpc_security_group_key_list = optional(list(string))
  }))
}

variable "cluster_allow_major_version_upgrade_default" {
  type    = bool
  default = false
}

variable "cluster_apply_immediately_default" {
  type    = bool
  default = false
}

variable "cluster_backup_retention_period_day_default" {
  type    = number
  default = 7
  validation {
    condition     = 1 <= var.cluster_backup_retention_period_day_default && var.cluster_backup_retention_period_day_default <= 35
    error_message = "Invalid retention period"
  }
  description = "A medium-severity security finding if set less than 7."
}

variable "cluster_backup_window_utc_default" {
  type        = string
  default     = "05:00-07:00"
  description = "Backup and maintenance windows cannot overlap"
}

variable "cluster_cloudwatch_log_export_list_default" {
  type        = list(string)
  default     = ["audit"]
  description = "Audit export is a Security Hub control (DocumentDB.4). Exporting profiler logs also requires the profiler parameter to be enabled."
}

variable "cluster_deletion_protection_default" {
  type        = bool
  default     = true
  description = "A medium-severity security finding if disabled."
}

variable "cluster_engine_default" {
  type    = string
  default = "docdb"
}

variable "cluster_engine_version_default" {
  type    = string
  default = "8.0.0"
}

variable "cluster_final_snapshot_enabled_default" {
  type    = bool
  default = true
}

variable "cluster_instance_map_default" {
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
  default = {
    a = {}
  }
  description = "Instances for a cluster that does not specify its own"
}

variable "cluster_kms_key_id_default" {
  type    = string
  default = null
}

variable "cluster_maintenance_window_utc_default" {
  type        = string
  default     = "Sun:07:00-Sun:08:00"
  description = "Backup and maintenance windows cannot overlap"
}

variable "cluster_network_type_default" {
  type    = string
  default = null
  validation {
    condition     = var.cluster_network_type_default == null ? true : contains(["DUAL", "IPV4"], var.cluster_network_type_default)
    error_message = "Invalid network type"
  }
}

variable "cluster_parameter_group_name_default" {
  type        = string
  default     = null
  description = "Null uses the AWS default cluster parameter group"
}

variable "cluster_port_default" {
  type    = number
  default = 27017
}

variable "cluster_secret_is_param_default" {
  type        = bool
  default     = false
  description = "If true, an SSM param will be created, otherwise a SM secret"
}

variable "cluster_snapshot_identifier_default" {
  type    = string
  default = null
}

variable "cluster_storage_encrypted_default" {
  type    = bool
  default = true
}

variable "cluster_storage_type_default" {
  type    = string
  default = null
  validation {
    condition     = var.cluster_storage_type_default == null ? true : contains(["iopt1", "standard"], var.cluster_storage_type_default)
    error_message = "Invalid storage type"
  }
}

variable "cluster_subnet_group_name_default" {
  type    = string
  default = null
}

variable "cluster_username_default" {
  type    = string
  default = null
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

variable "password_secret_name_append_default" {
  type    = string
  default = "db"
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

variable "vpc_data_map" {
  type = map(object({
    name_simple           = string
    security_group_id_map = map(string)
    segment_map = map(object({
      route_public  = bool
      subnet_id_map = map(string)
      subnet_map = map(object({
        availability_zone_name = string
      }))
    }))
    vpc_assign_ipv6_cidr = bool
    vpc_cidr_block       = string
    vpc_id               = string
    vpc_ipv6_cidr_block  = string
  }))
}

variable "vpc_key_default" {
  type    = string
  default = null
}

variable "vpc_security_group_key_list_default" {
  type = list(string)
  default = [
    "internal_mongodb_in",
    "world_all_out",
  ]
}
