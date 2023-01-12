variable "db_map" {
  type = map(object({
    active_directory_domain                   = optional(string)
    allocated_storage_gib                     = optional(number)
    allocated_storage_max_gib                 = optional(number) # Set nonzero to enable storage autoscaling
    allow_major_version_upgrade               = optional(bool)
    apply_immediately                         = optional(bool)
    auto_minor_version_upgrade                = optional(bool)
    availability_zone                         = optional(string)
    backup_retention_period_day               = optional(number)
    backup_window_utc                         = optional(string)
    blue_green_update_enabled                 = optional(bool)
    ca_cert_identifier                        = optional(string)
    character_set_name                        = optional(string)       # For Oracle and Microsoft SQL
    cloudwatch_log_export_list                = optional(list(string)) # See per-engine value here: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#enabled_db_enabled_cloudwatch_log_export_defaults
    copy_tags_to_snapshot                     = optional(bool)
    delete_automated_backups                  = optional(bool)
    deletion_protection                       = optional(bool)
    engine                                    = optional(string) # Do not spec for replica
    engine_version                            = optional(string) # Do not spec for replica; changes ignored
    final_snapshot_identifier                 = optional(string) # Do not spec for replica, if provided final snapshot is enabled
    iam_database_authentication_enabled       = optional(bool)
    iam_instance_profile_arn_custom           = optional(bool)
    iam_role_arn_monitoring                   = optional(string)
    iam_role_name_active_directory_domain     = optional(string)
    instance_class                            = optional(string)
    instance_identifier                       = optional(string) # Required for point in time
    instance_identifier_prefix                = optional(bool)
    kms_key_id                                = optional(string)
    license_model                             = optional(string) # Only for Oracle
    maintenance_window_utc                    = optional(string)
    monitoring_interval_s                     = optional(number)
    multi_az                                  = optional(bool)
    name_infix                                = optional(bool)
    nchar_character_set_name                  = optional(string) # Oracle only
    network_type                              = optional(string)
    option_group_name                         = optional(string)
    parameter_group_name                      = optional(string)
    password                                  = optional(string) # Changes ignored
    performance_insights_kms_key_arn          = optional(string)
    performance_insights_retention_period_day = optional(number)
    port                                      = optional(number)
    provisioned_iops                          = optional(number) # Will override storage type
    publicly_accessible                       = optional(bool)
    replica_mode_for_oracle                   = optional(string)
    replicate_source_db_id                    = optional(string)
    security_group_name_list                  = optional(list(string))
    snapshot_identifier                       = optional(string)
    storage_encrypted                         = optional(bool)
    storage_throughput                        = optional(number)
    storage_type                              = optional(string)
    subnet_group_name                         = optional(string) # For read replica, only if writer in different region
    timezone_for_ms_sql                       = optional(string)
    username                                  = optional(string)
  }))
}

variable "db_active_directory_domain_default" {
  type    = string
  default = null
}

variable "db_allocated_storage_gib_default" {
  type    = number
  default = 30
}

variable "db_allocated_storage_max_gib_default" {
  type    = number
  default = 0
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

variable "db_availability_zone_default" {
  type    = string
  default = null
}

variable "db_backup_retention_period_day_default" {
  type    = number
  default = 0
}

variable "db_backup_window_utc_default" {
  type    = string
  default = null
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

variable "db_cloudwatch_log_export_list_default" {
  type    = list(string)
  default = []
}

variable "db_copy_tags_to_snapshot_default" {
  type    = bool
  default = true
}

variable "db_delete_automated_backups_default" {
  type    = bool
  default = true
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
  default = false
}

variable "db_iam_instance_profile_arn_custom_default" {
  type    = string
  default = null
}

variable "db_iam_role_arn_monitoring_default" {
  type    = string
  default = null
}

variable "db_iam_role_name_active_directory_domain_default" {
  type    = string
  default = null
}

variable "db_instance_class_default" {
  type    = string
  default = null
}

variable "db_instance_identifier_prefix_default" {
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
  type    = string
  default = null
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

variable "db_name_infix_default" {
  type    = bool
  default = true
}

variable "db_nchar_character_set_name_default" {
  type    = string
  default = null
}

variable "db_network_type_default" {
  type    = string
  default = "IPV4"
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

variable "db_password_default" {
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

variable "db_security_group_name_list_default" {
  type    = list(string)
  default = null
}

variable "db_snapshot_identifier_default" {
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

variable "db_subnet_group_name_default" {
  type    = string
  default = null
}

variable "db_timezone_for_ms_sql_default" {
  type    = string
  default = null
}

variable "db_username_default" {
  type    = string
  default = null
}

variable "sg_map" {
  type = map(object({
    id = string
  }))
}

variable "std_map" {
  type = object({
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}
