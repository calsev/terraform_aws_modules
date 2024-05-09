module "log" {
  source  = "../../cw/log_group"
  log_map = local.create_log_map
  std_map = var.std_map
}

resource "aws_elasticache_cluster" "this_cluster" {
  for_each                   = local.create_cluster_map
  apply_immediately          = each.value.apply_change_immediately
  auto_minor_version_upgrade = each.value.auto_minor_version_upgrade_enabled
  availability_zone          = each.value.availability_zone_name
  az_mode                    = each.value.az_mode
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
  num_cache_nodes              = each.value.num_cache_nodes
  outpost_mode                 = each.value.outpost_mode
  parameter_group_name         = each.value.parameter_group_name
  port                         = each.value.port
  preferred_availability_zones = each.value.preferred_availability_zone_name_list
  preferred_outpost_arn        = each.value.preferred_outpost_arn
  replication_group_id         = each.value.replication_group_id
  security_group_ids           = each.value.vpc_security_group_id_list
  snapshot_arns                = each.value.snapshot_arn == null ? [] : [each.value.snapshot_arn]
  snapshot_name                = each.value.snapshot_name
  snapshot_retention_limit     = each.value.snapshot_retention_days
  snapshot_window              = each.value.snapshot_window_utc
  subnet_group_name            = each.value.subnet_group_name
  tags                         = each.value.tags
  transit_encryption_enabled   = each.value.transit_encryption_enabled
}
