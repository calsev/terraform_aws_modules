module "log" {
  source  = "../../cw/log_group"
  log_map = local.create_log_map
  std_map = var.std_map
}

resource "aws_elasticache_cluster" "this_cluster" {
  for_each                   = local.create_cluster_x_map
  apply_immediately          = each.value.apply_change_immediately
  auto_minor_version_upgrade = each.value.auto_minor_version_upgrade_enabled
  availability_zone          = each.value.availability_zone_name
  az_mode                    = each.value.multi_az_enabled ? "cross-az" : "single-az"
  cluster_id                 = each.value.name_effective
  engine                     = each.value.engine
  engine_version             = each.value.engine_version
  final_snapshot_identifier  = each.value.final_snapshot_identifier
  ip_discovery               = each.value.ip_discovery_mode
  dynamic "log_delivery_configuration" {
    for_each = each.value.log_map
    content {
      destination      = log_delivery_configuration.value.log_destination_name
      destination_type = log_delivery_configuration.key
      log_format       = log_delivery_configuration.value.log_format
      log_type         = log_delivery_configuration.value.log_type
    }
  }
  maintenance_window           = each.value.maintenance_window_utc
  network_type                 = each.value.network_type
  node_type                    = each.value.node_type
  notification_topic_arn       = each.value.notification_topic_arn
  num_cache_nodes              = each.value.shard_count
  outpost_mode                 = each.value.outpost_mode
  parameter_group_name         = each.value.parameter_group_name
  port                         = each.value.port
  preferred_availability_zones = each.value.preferred_availability_zone_name_list
  preferred_outpost_arn        = each.value.preferred_outpost_arn
  region                       = var.std_map.aws_region_name
  replication_group_id         = each.value.replication_group_id
  security_group_ids           = each.value.vpc_security_group_id_list
  snapshot_arns                = each.value.snapshot_arn == null ? [] : [each.value.snapshot_arn]
  snapshot_name                = each.value.snapshot_name
  snapshot_retention_limit     = each.value.snapshot_retention_days
  snapshot_window              = each.value.snapshot_window_utc
  subnet_group_name            = each.value.subnet_group_name
  tags                         = each.value.tags
  transit_encryption_enabled   = each.value.transit_encryption_required
}

resource "aws_elasticache_replication_group" "this_cluster" {
  for_each                    = local.create_group_x_map
  apply_immediately           = each.value.apply_change_immediately
  at_rest_encryption_enabled  = each.value.encryption_at_rest_enabled
  auth_token                  = null # AUTH
  auth_token_update_strategy  = null # AUTH
  auto_minor_version_upgrade  = each.value.auto_minor_version_upgrade_enabled
  automatic_failover_enabled  = each.value.automatic_failover_enabled
  cluster_mode                = each.value.cluster_mode
  data_tiering_enabled        = each.value.data_tiering_enabled
  description                 = each.value.name_effective
  engine                      = each.value.engine
  engine_version              = each.value.engine_version
  final_snapshot_identifier   = each.value.final_snapshot_identifier
  global_replication_group_id = null # GLOBAL
  ip_discovery                = each.value.ip_discovery_mode
  kms_key_id                  = each.value.kms_key_id
  dynamic "log_delivery_configuration" {
    for_each = each.value.log_map
    content {
      destination      = log_delivery_configuration.value.log_destination_name
      destination_type = log_delivery_configuration.key
      log_format       = log_delivery_configuration.value.log_format
      log_type         = log_delivery_configuration.value.log_type
    }
  }
  maintenance_window     = each.value.maintenance_window_utc
  multi_az_enabled       = each.value.multi_az_enabled
  network_type           = each.value.network_type
  node_type              = each.value.node_type
  notification_topic_arn = each.value.notification_topic_arn
  num_cache_clusters     = null # Conflicts with num_node_groups, replicas_per_node_group
  # node_group_configuration # TODO
  num_node_groups             = each.value.shard_count
  parameter_group_name        = each.value.parameter_group_name
  port                        = each.value.port
  preferred_cache_cluster_azs = each.value.preferred_availability_zone_name_list
  replicas_per_node_group     = each.value.shard_replica_count
  region                      = var.std_map.aws_region_name
  replication_group_id        = each.value.name_effective
  security_group_ids          = each.value.vpc_security_group_id_list
  security_group_names        = null
  snapshot_arns               = each.value.snapshot_arn == null ? [] : [each.value.snapshot_arn]
  snapshot_name               = each.value.snapshot_name
  snapshot_retention_limit    = each.value.snapshot_retention_days
  snapshot_window             = each.value.snapshot_window_utc
  subnet_group_name           = each.value.subnet_group_name
  tags                        = each.value.tags
  transit_encryption_enabled  = true
  transit_encryption_mode     = each.value.transit_encryption_required ? "required" : "preferred"
  user_group_ids              = null # AUTH
}
