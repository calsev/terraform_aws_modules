variable "engine_to_security_group_key_list" {
  type = map(list(string))
  default = {
    mysql = [
      "internal_mysql_in",
      "world_all_out",
    ]
    postgres = [
      "internal_postgres_in",
      "world_all_out",
    ]
  }
  description = "A list of engine to security group key"
}

variable "db_map" {
  type = map(object({
    active_directory_domain               = optional(string)
    allocated_storage_gib                 = optional(number)
    allocated_storage_max_gib             = optional(number) # Set nonzero to enable storage autoscaling
    allow_major_version_upgrade           = optional(bool)
    apply_immediately                     = optional(bool)
    auto_minor_version_upgrade            = optional(bool)
    availability_zone_key                 = optional(string)
    backup_retention_period_day           = optional(number)
    backup_window_utc                     = optional(string)
    blue_green_update_enabled             = optional(bool)
    ca_cert_identifier                    = optional(string)
    character_set_name                    = optional(string)       # For Oracle and Microsoft SQL
    cloudwatch_log_export_list            = optional(list(string)) # See per-engine value here: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#enabled_db_enabled_cloudwatch_log_export_defaults
    create_instance                       = optional(bool)
    copy_tags_to_snapshot                 = optional(bool)
    db_initial_name                       = optional(string)
    delete_automated_backups              = optional(bool)
    deletion_protection                   = optional(bool)
    engine                                = optional(string) # Do not spec for replica
    engine_version                        = optional(string) # Do not spec for replica; changes ignored
    final_snapshot_enabled                = optional(bool)
    final_snapshot_identifier             = optional(string) # Defaults to name_effective
    iam_database_authentication_enabled   = optional(bool)
    iam_instance_profile_arn_custom       = optional(bool)
    iam_role_name_active_directory_domain = optional(string)
    #    ignore_change_list                        = optional(list(string))
    instance_class                            = optional(string)
    instance_identifier_is_prefix             = optional(bool)
    kms_key_id                                = optional(string)
    license_model                             = optional(string) # Only for Oracle
    maintenance_window_utc                    = optional(string)
    monitoring_interval_s                     = optional(number)
    multi_az                                  = optional(bool)
    name_include_app_fields                   = optional(bool)
    name_infix                                = optional(bool)
    name_prefix                               = optional(string)
    name_suffix                               = optional(string)
    nchar_character_set_name                  = optional(string) # Oracle and MSSQL only
    network_type                              = optional(string)
    option_group_name                         = optional(string)
    parameter_group_name                      = optional(string)
    performance_insights_kms_key_arn          = optional(string)
    performance_insights_retention_period_day = optional(number)
    port                                      = optional(number)
    provisioned_iops                          = optional(number) # Will override storage type
    publicly_accessible                       = optional(bool)
    replica_mode_for_oracle                   = optional(string)
    replicate_source_db_id                    = optional(string)
    snapshot_arn                              = optional(string)
    storage_encrypted                         = optional(bool)
    storage_throughput                        = optional(number)
    storage_type                              = optional(string)
    subnet_group_key                          = optional(string) # For read replica, only if writer in different region
    timezone_for_ms_sql                       = optional(string)
    secret_is_param                           = optional(bool)
    username                                  = optional(string)
  }))
}

variable "db_active_directory_domain_default" {
  type    = string
  default = null
}

variable "db_allocated_storage_gib_default" {
  type    = number
  default = 20
  validation {
    condition     = 20 <= var.db_allocated_storage_gib_default
    error_message = "Minimum storage is 20 GiB"
  }
}

variable "db_allocated_storage_max_gib_default" {
  type    = number
  default = 80
}

variable "db_allow_major_version_upgrade_default" {
  type    = bool
  default = false
}

variable "db_apply_immediately_default" {
  type    = bool
  default = false
}

variable "db_auto_minor_version_upgrade_default" {
  type    = bool
  default = true
}

variable "db_availability_zone_key_default" {
  type    = string
  default = "a"
}

variable "db_backup_retention_period_day_default" {
  type    = number
  default = 14
  validation {
    condition     = 0 <= var.db_backup_retention_period_day_default && var.db_backup_retention_period_day_default <= 35
    error_message = "Invalid retention period"
  }
  description = "Must be greater than zero for a replication source"
}

variable "db_backup_window_utc_default" {
  type        = string
  default     = "06:00-07:00"
  description = "Backup and maintenance windows cannot overlap"
}

variable "db_blue_green_update_enabled_default" {
  type    = bool
  default = false
}

variable "db_ca_cert_identifier_default" {
  type    = string
  default = null
}

variable "db_character_set_name_default" {
  type    = string
  default = null
}

variable "db_cloudwatch_log_export_list_map_default" {
  type = map(list(string))
  default = {
    db2       = ["diag.log", "notify.log"]
    mariadb   = ["audit", "error", "general", "slowquery"]
    mysql     = ["audit", "error", "general", "slowquery"]
    oracle    = ["alert", "audit", "listener", "trace"] # oemagent
    postgres  = ["postgresql", "upgrade"]
    sqlserver = ["agent", "error"]
  }
  description = "A map of engine family to log exports. See https://docs.aws.amazon.com/securityhub/latest/userguide/rds-controls.html#rds-9"
}

variable "db_copy_tags_to_snapshot_default" {
  type    = bool
  default = true
}

variable "db_create_instance_default" {
  type        = bool
  default     = true
  description = "If false, all values will be calcualted and all resources but the instance will be created."
}

variable "db_delete_automated_backups_default" {
  type    = bool
  default = false
}

variable "db_deletion_protection_default" {
  type    = bool
  default = true
}

variable "db_engine_default" {
  type    = string
  default = null
}

variable "db_engine_version_default" {
  type    = string
  default = null
}

variable "db_iam_database_authentication_enabled_default" {
  type    = bool
  default = true
}

variable "db_iam_instance_profile_arn_custom_default" {
  type    = string
  default = null
}

variable "db_iam_role_name_active_directory_domain_default" {
  type    = string
  default = null
}

variable "db_initial_name_default" {
  type    = string
  default = null
}

variable "db_instance_class_default" {
  type    = string
  default = "db.t4g.micro"
}

variable "db_instance_identifier_is_prefix_default" {
  type    = bool
  default = false
}

variable "db_kms_key_id_default" {
  type    = string
  default = null
}

variable "db_license_model_default" {
  type    = string
  default = null
}

variable "db_maintenance_window_utc_default" {
  type        = string
  default     = "Sun:07:00-Sun:08:00"
  description = "Backup and maintenance windows cannot overlap"
}

variable "db_monitoring_interval_s_default" {
  type        = number
  default     = 60
  description = "The interval for collecting enhanced metrics. Set nonzero to enable enhanced metrics."
  validation {
    condition     = contains([0, 1, 5, 10, 15, 30, 60], var.db_monitoring_interval_s_default)
    error_message = "Invalid monitoring interval"
  }
}

variable "db_multi_az_default" {
  type    = bool
  default = false
}

variable "db_nchar_character_set_name_default" {
  type    = string
  default = null
}

variable "db_network_type_default" {
  type    = string
  default = "DUAL"
  validation {
    condition     = contains(["IPV4", "DUAL"], var.db_network_type_default)
    error_message = "Invalid networking type"
  }
}

variable "db_option_group_name_default" {
  type    = string
  default = null
}

variable "db_parameter_group_name_default" {
  type    = string
  default = null
}

variable "db_performance_insights_kms_key_arn_default" {
  type        = string
  default     = null
  description = "Must be null to disable performance insights"
}

variable "db_performance_insights_retention_period_day_default" {
  type        = number
  default     = 7
  description = "Must be null to disable performance insights. Up to 7 days is free."
  validation {
    condition     = contains([7, 31, 62, 93, 124, 155, 186, 217, 248, 279, 310, 341, 372, 403, 434, 465, 496, 527, 558, 589, 620, 651, 682, 713, 731], var.db_performance_insights_retention_period_day_default)
    error_message = "Invalid retention period"
  }
}

variable "db_port_default" {
  type        = number
  default     = null
  description = "Will default to engine-specific port"
}

variable "db_provisioned_iops_default" {
  type    = number
  default = null
}

variable "db_publicly_accessible_default" {
  type    = bool
  default = false
}

variable "db_replica_mode_for_oracle_default" {
  type    = string
  default = null
  validation {
    condition     = var.db_replica_mode_for_oracle_default == null ? true : contains(["mounted", "open-read-only"], var.db_replica_mode_for_oracle_default)
    error_message = "Invalid replica mode"
  }
}

variable "db_replicate_source_db_id_default" {
  type    = string
  default = null
}

variable "db_final_snapshot_enabled_default" {
  type        = bool
  default     = true
  description = "Do not spec for replica"
}

variable "db_snapshot_arn_default" {
  type    = string
  default = null
}

variable "db_storage_encrypted_default" {
  type    = bool
  default = true
}

variable "db_storage_throughput_default" {
  type    = number
  default = null
}

variable "db_storage_type_default" {
  type    = string
  default = "gp3"
}

variable "db_subnet_group_key_default" {
  type    = string
  default = null
}

variable "db_timezone_for_ms_sql_default" {
  type    = string
  default = null
}

variable "db_secret_is_param_default" {
  type        = bool
  default     = false
  description = "If true, an SSM param will be created, otherwise a SM secret"
}

variable "db_username_default" {
  type    = string
  default = null
}

variable "iam_data" {
  type = object({
    iam_role_arn_rds_monitor = string
  })
  default     = null
  description = "Must be provided if performance insights are enabled - they are by default"
}

variable "name_include_app_fields_default" {
  type        = bool
  default     = false
  description = "It is assumed the DB transcends app organization"
}

variable "name_infix_default" {
  type    = bool
  default = true
}

variable "name_prefix_default" {
  type        = string
  default     = ""
  description = "Prepended before context prefix"
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

variable "subnet_group_map" {
  type = map(object({
    name_effective  = string
    vpc_key         = string
    vpc_segment_key = string
  }))
}

variable "vpc_data_map" {
  type = map(object({
    security_group_id_map = map(string)
    segment_map = map(object({
      subnet_map = map(object({
        availability_zone_name = string
      }))
    }))
  }))
}

variable "std_map" {
  type = object({
    access_title_map               = map(string)
    aws_account_id                 = string
    aws_region_name                = string
    iam_partition                  = string
    name_replace_regex             = string
    resource_name_prefix           = string
    resource_name_suffix           = string
    service_resource_access_action = map(map(map(list(string))))
    tags                           = map(string)
  })
}
