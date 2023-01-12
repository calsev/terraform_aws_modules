resource "aws_db_instance" "this_db" {
  for_each                    = local.db_map
  allocated_storage           = each.value.allocated_storage_gib
  allow_major_version_upgrade = each.value.allow_major_version_upgrade
  apply_immediately           = each.value.apply_immediately
  auto_minor_version_upgrade  = each.value.auto_minor_version_upgrade
  availability_zone           = each.value.availability_zone
  backup_retention_period     = each.value.backup_retention_period_day
  backup_window               = each.value.backup_window_utc
  blue_green_update {
    enabled = each.value.blue_green_update_enabled
  }
  ca_cert_identifier    = each.value.ca_cert_identifier
  character_set_name    = each.value.character_set_name
  copy_tags_to_snapshot = each.value.copy_tags_to_snapshot
  # TODO: customer_owned_ip_enabled
  custom_iam_instance_profile         = each.value.iam_instance_profile_arn_custom
  db_name                             = each.value.name
  db_subnet_group_name                = each.value.subnet_group_name
  delete_automated_backups            = each.value.delete_automated_backups
  deletion_protection                 = each.value.deletion_protection
  domain                              = each.value.active_directory_domain
  domain_iam_role_name                = each.value.iam_role_name_active_directory_domain
  enabled_cloudwatch_logs_exports     = each.value.cloudwatch_log_export_list
  engine                              = each.value.engine
  engine_version                      = each.value.engine_version
  final_snapshot_identifier           = each.value.final_snapshot_identifier
  iam_database_authentication_enabled = each.value.iam_database_authentication_enabled
  identifier                          = each.value.instance_identifier_prefix == null ? null : each.value.instance_identifier
  identifier_prefix                   = each.value.instance_identifier_prefix == null ? each.value.instance_identifier : null
  instance_class                      = each.value.instance_class
  iops                                = each.value.provisioned_iops
  kms_key_id                          = each.value.kms_key_id
  license_model                       = each.value.license_model
  lifecycle {
    # This list must be static
    ignore_changes = [
      engine_version, # Allow auto updates
      password,       # Dirty because it is usually sensitive
    ]
  }
  maintenance_window                    = each.value.maintenance_window_utc
  max_allocated_storage                 = each.value.allocated_storage_max_gib
  monitoring_interval                   = each.value.monitoring_interval_s
  monitoring_role_arn                   = each.value.iam_role_arn_monitoring
  multi_az                              = each.value.multi_az
  nchar_character_set_name              = each.value.nchar_character_set_name
  network_type                          = each.value.network_type
  option_group_name                     = each.value.option_group_name
  parameter_group_name                  = each.value.parameter_group_name
  password                              = each.value.password
  performance_insights_enabled          = each.value.performance_insights_enabled
  performance_insights_kms_key_id       = each.value.performance_insights_kms_key_arn
  performance_insights_retention_period = each.value.performance_insights_retention_period_day
  port                                  = each.value.port
  publicly_accessible                   = each.value.publicly_accessible
  replica_mode                          = each.value.replica_mode_for_oracle
  replicate_source_db                   = each.value.replicate_source_db_id
  # TODO: restore_to_point_in_time
  # TODO: s3_import
  skip_final_snapshot = each.value.skip_final_snapshot
  snapshot_identifier = each.value.snapshot_identifier
  storage_encrypted   = each.value.storage_encrypted
  storage_throughput  = each.value.storage_throughput # TODO: mutex for iops and throughput
  storage_type        = each.value.storage_type
  tags                = each.value.tags
  timezone            = each.value.timezone_for_ms_sql
  username            = each.value.username
  vpc_security_group_ids = [
    for _, id in each.value.security_group_name_map : id
  ]
}
