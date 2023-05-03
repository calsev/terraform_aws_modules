module "name_map" {
  source             = "../name_map"
  name_infix_default = var.db_name_infix_default
  name_map           = var.db_map
  std_map            = var.std_map
}

locals {
  db_map = {
    for k, v in var.db_map : k => merge(local.l1_map[k], local.l2_map[k], local.l3_map[k])
  }
  l1_map = {
    for k, v in var.db_map : k => merge(v, module.name_map.data[k], {
      active_directory_domain                   = v.active_directory_domain == null ? var.db_active_directory_domain_default : v.active_directory_domain
      allocated_storage_gib                     = v.allocated_storage_gib == null ? var.db_allocated_storage_gib_default : v.allocated_storage_gib
      allocated_storage_max_gib                 = v.allocated_storage_max_gib == null ? var.db_allocated_storage_max_gib_default : v.allocated_storage_max_gib
      allow_major_version_upgrade               = v.allow_major_version_upgrade == null ? var.db_allow_major_version_upgrade_default : v.allow_major_version_upgrade
      auto_minor_version_upgrade                = v.auto_minor_version_upgrade == null ? var.db_auto_minor_version_upgrade_default : v.auto_minor_version_upgrade
      apply_immediately                         = v.apply_immediately == null ? var.db_apply_immediately_default : v.apply_immediately
      availability_zone                         = v.availability_zone == null ? var.db_availability_zone_default : v.availability_zone
      backup_retention_period_day               = v.backup_retention_period_day == null ? var.db_backup_retention_period_day_default : v.backup_retention_period_day
      backup_window_utc                         = v.backup_window_utc == null ? var.db_backup_window_utc_default : v.backup_window_utc
      blue_green_update_enabled                 = v.blue_green_update_enabled == null ? var.db_blue_green_update_enabled_default : v.blue_green_update_enabled
      ca_cert_identifier                        = v.ca_cert_identifier == null ? var.db_ca_cert_identifier_default : v.ca_cert_identifier
      character_set_name                        = v.character_set_name == null ? var.db_character_set_name_default : v.character_set_name
      cloudwatch_log_export_list                = v.cloudwatch_log_export_list == null ? var.db_cloudwatch_log_export_list_default : v.cloudwatch_log_export_list
      copy_tags_to_snapshot                     = v.copy_tags_to_snapshot == null ? var.db_copy_tags_to_snapshot_default : v.copy_tags_to_snapshot
      db_name_initial                           = v.db_name_initial == null ? var.db_name_initial_default : v.db_name_initial
      delete_automated_backups                  = v.delete_automated_backups == null ? var.db_delete_automated_backups_default : v.delete_automated_backups
      deletion_protection                       = v.deletion_protection == null ? var.db_deletion_protection_default : v.deletion_protection
      engine                                    = v.engine == null ? var.db_engine_default : v.engine
      engine_version                            = v.engine_version == null ? var.db_engine_version_default : v.engine_version
      final_snapshot_enabled                    = v.final_snapshot_enabled == null ? var.db_final_snapshot_enabled_default : v.final_snapshot_enabled
      iam_database_authentication_enabled       = v.iam_database_authentication_enabled == null ? var.db_iam_database_authentication_enabled_default : v.iam_database_authentication_enabled
      iam_instance_profile_arn_custom           = v.iam_instance_profile_arn_custom == null ? var.db_iam_instance_profile_arn_custom_default : v.iam_instance_profile_arn_custom
      iam_role_name_active_directory_domain     = v.iam_role_name_active_directory_domain == null ? var.db_iam_role_name_active_directory_domain_default : v.iam_role_name_active_directory_domain
      instance_class                            = v.instance_class == null ? var.db_instance_class_default : v.instance_class
      instance_identifier_is_prefix             = v.instance_identifier_is_prefix == null ? var.db_instance_identifier_is_prefix_default : v.instance_identifier_is_prefix
      kms_key_id                                = v.kms_key_id == null ? var.db_kms_key_id_default : v.kms_key_id
      license_model                             = v.license_model == null ? var.db_license_model_default : v.license_model
      maintenance_window_utc                    = v.maintenance_window_utc == null ? var.db_maintenance_window_utc_default : v.maintenance_window_utc
      monitoring_interval_s                     = v.monitoring_interval_s == null ? var.db_monitoring_interval_s_default : v.monitoring_interval_s
      multi_az                                  = v.multi_az == null ? var.db_multi_az_default : v.multi_az
      nchar_character_set_name                  = v.nchar_character_set_name == null ? var.db_nchar_character_set_name_default : v.nchar_character_set_name
      network_type                              = v.network_type == null ? var.db_network_type_default : v.network_type
      option_group_name                         = v.option_group_name == null ? var.db_option_group_name_default : v.option_group_name
      parameter_group_name                      = v.parameter_group_name == null ? var.db_parameter_group_name_default : v.parameter_group_name
      password_ssm_param_name                   = v.password_ssm_param_name == null ? var.db_password_ssm_param_name_default : v.password_ssm_param_name
      password_sm_secret_name                   = v.password_sm_secret_name == null ? var.db_password_sm_secret_name_default : v.password_sm_secret_name
      password_sm_secret_key                    = v.password_sm_secret_key == null ? var.db_password_sm_secret_key_default : v.password_sm_secret_key
      performance_insights_kms_key_arn          = v.performance_insights_kms_key_arn == null ? var.db_performance_insights_kms_key_arn_default : v.performance_insights_kms_key_arn
      performance_insights_retention_period_day = v.performance_insights_retention_period_day == null ? var.db_performance_insights_retention_period_day_default : v.performance_insights_retention_period_day
      port                                      = v.port == null ? var.db_port_default : v.port
      provisioned_iops                          = v.provisioned_iops == null ? var.db_provisioned_iops_default : v.provisioned_iops
      publicly_accessible                       = v.publicly_accessible == null ? var.db_publicly_accessible_default : v.publicly_accessible
      replica_mode_for_oracle                   = v.replica_mode_for_oracle == null ? var.db_replica_mode_for_oracle_default : v.replica_mode_for_oracle
      replicate_source_db_id                    = v.replicate_source_db_id == null ? var.db_replicate_source_db_id_default : v.replicate_source_db_id4
      snapshot_identifier                       = v.snapshot_identifier == null ? var.db_snapshot_identifier_default : v.snapshot_identifier
      storage_encrypted                         = v.storage_encrypted == null ? var.db_storage_encrypted_default : v.storage_encrypted
      storage_throughput                        = v.storage_throughput == null ? var.db_storage_throughput_default : v.storage_throughput
      subnet_group_key                          = v.subnet_group_key == null ? var.db_subnet_group_key_default : v.subnet_group_key
      timezone_for_ms_sql                       = v.timezone_for_ms_sql == null ? var.db_timezone_for_ms_sql_default : v.timezone_for_ms_sql
      username                                  = v.username == null ? var.db_username_default : v.username
    })
  }
  l2_map = {
    for k, v in var.db_map : k => {
      final_snapshot_identifier = v.final_snapshot_identifier == null ? local.l1_map[k].name_effective : v.final_snapshot_identifier
      #      ignore_change_map = merge(
      #        {
      #          for k_attrib in v.ignore_change_list == null ? var.db_ignore_change_list_default : v.ignore_change_list : k_attrib => null
      #        },
      #        local.l1_map[k].allow_major_version_upgrade || local.l1_map[k].auto_minor_version_upgrade ? { engine_version = null } : {}
      #      )
      performance_insights_enabled = local.l1_map[k].performance_insights_kms_key_arn != null || !contains([0, null], local.l1_map[k].performance_insights_retention_period_day)
      storage_type                 = local.l1_map[k].provisioned_iops == null ? v.storage_type == null ? var.db_storage_type_default : v.storage_type : "io1"
      subnet_group_name            = var.subnet_group_map[local.l1_map[k].subnet_group_key].name_effective
      vpc_key                      = var.subnet_group_map[local.l1_map[k].subnet_group_key].vpc_key
    }
  }
  l3_map = {
    for k, v in var.db_map : k => {
      iam_role_arn_monitoring = local.l2_map[k].performance_insights_enabled ? var.iam_data.iam_role_arn_rds_monitor : null
      #ignore_change_list = [
      #  for k_attrib, _ in local.l2_map[k].ignore_change_map : k_attrib
      #]
      security_group_id_list = sort([
        for k_sg in var.engine_to_security_group_key_list[local.l1_map[k].engine] : var.vpc_data_map[local.l2_map[k].vpc_key].security_group_id_map[k_sg]
      ])
    }
  }
  output_data = {
    for k, v in local.db_map : k => merge(v, {
      db_domain_name = aws_db_instance.this_db[k].address
      db_arn         = aws_db_instance.this_db[k].arn
      db_id          = aws_db_instance.this_db[k].id
    })
  }
}
