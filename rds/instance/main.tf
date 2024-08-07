module "password_secret" {
  source                                      = "../../secret/random"
  name_include_app_fields_default             = var.name_include_app_fields_default
  name_infix_default                          = var.name_infix_default
  name_prefix_default                         = var.name_prefix_default
  name_suffix_default                         = var.name_suffix_default
  secret_is_param_default                     = var.db_secret_is_param_default
  secret_map                                  = local.create_password_map
  secret_random_init_key_default              = "password"
  secret_random_special_character_set_default = "!#$%&*()-_=+[]{}<>:?" # @ not allowed
  std_map                                     = var.std_map
}

resource "aws_db_instance" "this_db" {
  for_each                    = local.create_instance_map
  allocated_storage           = each.value.allocated_storage_gib
  allow_major_version_upgrade = each.value.allow_major_version_upgrade
  apply_immediately           = each.value.apply_immediately
  auto_minor_version_upgrade  = each.value.auto_minor_version_upgrade
  availability_zone           = each.value.availability_zone_name
  backup_retention_period     = each.value.backup_retention_period_day
  backup_target               = "region" # Other option is outpost
  backup_window               = each.value.backup_window_utc
  blue_green_update {
    enabled = each.value.blue_green_update_enabled
  }
  ca_cert_identifier    = each.value.ca_cert_identifier
  character_set_name    = each.value.character_set_name
  copy_tags_to_snapshot = each.value.copy_tags_to_snapshot
  # TODO: customer_owned_ip_enabled
  custom_iam_instance_profile         = each.value.iam_instance_profile_arn_custom
  db_name                             = each.value.db_initial_name
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
  identifier                          = each.value.instance_identifier_is_prefix == null ? null : each.value.name_effective
  identifier_prefix                   = each.value.instance_identifier_is_prefix == null ? each.value.name_effective : null
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
  maintenance_window          = each.value.maintenance_window_utc
  manage_master_user_password = null # Conflicts with password
  # master_user_secret # For RDS-managed
  max_allocated_storage                 = each.value.allocated_storage_max_gib
  monitoring_interval                   = each.value.monitoring_interval_s
  monitoring_role_arn                   = each.value.iam_role_arn_monitoring
  multi_az                              = each.value.multi_az
  nchar_character_set_name              = each.value.nchar_character_set_name
  network_type                          = each.value.network_type
  option_group_name                     = each.value.option_group_name
  parameter_group_name                  = each.value.parameter_group_name
  password                              = jsondecode(module.password_secret.secret_map[each.key])["password"]
  performance_insights_enabled          = each.value.performance_insights_enabled
  performance_insights_kms_key_id       = each.value.performance_insights_kms_key_arn
  performance_insights_retention_period = each.value.performance_insights_retention_period_day
  port                                  = each.value.port
  publicly_accessible                   = each.value.publicly_accessible
  replica_mode                          = each.value.replica_mode_for_oracle
  replicate_source_db                   = each.value.replicate_source_db_id
  # TODO: restore_to_point_in_time
  # TODO: s3_import
  skip_final_snapshot    = !each.value.final_snapshot_enabled
  snapshot_identifier    = each.value.snapshot_arn
  storage_encrypted      = each.value.storage_encrypted
  storage_throughput     = each.value.storage_throughput # TODO: mutex for iops and throughput
  storage_type           = each.value.storage_type
  tags                   = each.value.tags
  timezone               = each.value.timezone_for_ms_sql
  username               = each.value.username
  vpc_security_group_ids = each.value.security_group_id_list
}
