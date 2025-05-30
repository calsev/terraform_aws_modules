{{ name.map() }}

module "vpc_map" {
  source                              = "../../vpc/id_map"
  vpc_map                             = local.l0_map
  vpc_az_key_list_default             = var.vpc_az_key_list_default
  vpc_key_default                     = var.vpc_key_default
  vpc_security_group_key_list_default = var.vpc_security_group_key_list_default
  vpc_segment_key_default             = var.vpc_segment_key_default
  vpc_data_map                        = var.vpc_data_map
}

locals {
  create_log_map = {
    for k, v in local.lx_map : "cache_${k}" => v if v.create_log_group
  }
  create_cluster_map = {
    for k, v in local.lx_map : k => merge(v, {
      log_map = {
        for k_log, v_log in v.log_map : k_log => merge(v_log, {
          log_destination_name = v_log.log_destination_name == null ? module.log.data["cache_${k}"].name_effective : v_log.log_destination_name
        })
      }
    })
  }
  l0_map = {
    for k, v in var.cluster_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], module.vpc_map.data[k], {
      apply_change_immediately           = v.apply_change_immediately == null ? var.cluster_apply_change_immediately_default : v.apply_change_immediately
      auto_minor_version_upgrade_enabled = v.auto_minor_version_upgrade_enabled == null ? var.cluster_auto_minor_version_upgrade_enabled_default : v.auto_minor_version_upgrade_enabled
      engine                             = v.engine == null ? var.cluster_engine_default : v.engine
      engine_version                     = v.engine_version == null ? var.cluster_engine_version_default : v.engine_version
      final_snapshot_enabled             = v.final_snapshot_enabled == null ? var.cluster_final_snapshot_enabled_default : v.final_snapshot_enabled
      ip_discovery_v6                    = v.ip_discovery_v6 == null ? var.cluster_ip_discovery_v6_default : v.ip_discovery_v6
      maintenance_window_utc             = v.maintenance_window_utc == null ? var.cluster_maintenance_window_utc_default : v.maintenance_window_utc
      network_type                       = v.network_type == null ? var.cluster_network_type_default : v.network_type
      node_type                          = v.node_type == null ? var.cluster_node_type_default : v.node_type
      notification_topic_arn             = v.notification_topic_arn == null ? var.cluster_notification_topic_arn_default : v.notification_topic_arn
      num_cache_nodes                    = v.num_cache_nodes == null ? var.cluster_num_cache_nodes_default : v.num_cache_nodes
      parameter_group_name               = v.parameter_group_name == null ? var.cluster_parameter_group_name_default : v.parameter_group_name
      port                               = v.port == null ? var.cluster_port_default : v.port
      preferred_outpost_arn              = v.preferred_outpost_arn == null ? var.cluster_preferred_outpost_arn_default : v.preferred_outpost_arn
      replication_group_id               = v.replication_group_id == null ? var.cluster_replication_group_id_default : v.replication_group_id
      snapshot_retention_days            = v.snapshot_retention_days == null ? var.cluster_snapshot_retention_days_default : v.snapshot_retention_days
      snapshot_window_utc                = v.snapshot_window_utc == null ? var.cluster_snapshot_window_utc_default : v.snapshot_window_utc
      subnet_group_key                   = v.subnet_group_key == null ? var.cluster_subnet_group_key_default : v.subnet_group_key
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      az_mode                              = local.l1_map[k].engine == "memcached" ? v.az_mode == null ? var.cluster_az_mode_default : v.az_mode : null
      final_snapshot_identifier            = local.l1_map[k].final_snapshot_enabled ? local.l1_map[k].name_effective : null
      ip_discovery_mode                    = local.l1_map[k].num_cache_nodes > 1 ? local.l1_map[k].ip_discovery_v6 ? "ipv6" : "ipv4" : null
      log_map                              = local.l1_map[k].engine == "redis" ? v.log_map == null ? var.cluster_log_map_default : v.log_map : {}
      outpost_mode                         = local.l1_map[k].preferred_outpost_arn == null ? null : v.outpost_mode == null ? var.cluster_outpost_mode_default : v.outpost_mode
      port                                 = local.l1_map[k].port == null ? local.l1_map[k].engine == "memcached" ? 11211 : 6379 : local.l1_map[k].port
      preferred_availability_zone_key_list = local.l1_map[k].engine == "memcached" ? v.preferred_availability_zone_key_list == null ? var.cluster_preferred_availability_zone_key_list_default : v.preferred_availability_zone_key_list : null
      snapshot_arn                         = local.l1_map[k].engine == "redis" ? v.snapshot_arn == null ? var.cluster_snapshot_arn_default : v.snapshot_arn : null
      snapshot_name                        = local.l1_map[k].engine == "redis" ? v.snapshot_name == null ? var.cluster_snapshot_name_default : v.snapshot_name : null
      subnet_group_name                    = var.subnet_group_map[local.l1_map[k].subnet_group_key].name_effective
      transit_encryption_enabled           = local.l1_map[k].engine == "memcached" ? v.transit_encryption_enabled == null ? var.cluster_transit_encryption_enabled_default : v.transit_encryption_enabled : null
    }
  }
  l3_map = {
    for k, v in local.l0_map : k => {
      availability_zone_key = local.l2_map[k].preferred_availability_zone_key_list == null ? v.availability_zone_key == null ? var.cluster_availability_zone_key_default : v.availability_zone_key : null
      log_map = {
        for k_log, v_log in local.l2_map[k].log_map : k_log => merge(v_log, {
          log_destination_name = v_log.log_destination_name == null ? var.cluster_log_destination_name_default : v_log.log_destination_name
          log_format           = v_log.log_format == null ? var.cluster_log_format_default : v_log.log_format
          log_type             = v_log.log_type == null ? var.cluster_log_type_default : v_log.log_type
        })
      }
      preferred_availability_zone_name_list = local.l2_map[k].preferred_availability_zone_key_list == null ? null : [
        for k_az in local.l2_map[k].preferred_availability_zone_key_list : var.vpc_data_map[local.l1_map[k].vpc_key].segment_map[local.l1_map[k].vpc_segment_key].subnet_map[k_az].availability_zone_name
      ]
    }
  }
  l4_map = {
    for k, v in local.l0_map : k => {
      availability_zone_name = local.l3_map[k].availability_zone_key == null ? null : var.vpc_data_map[local.l1_map[k].vpc_key].segment_map[local.l1_map[k].vpc_segment_key].subnet_map[local.l3_map[k].availability_zone_key].availability_zone_name
      create_log_group = anytrue([
        for _, v_log in local.l3_map[k].log_map : v_log.log_destination_name == null
      ])
    }
  }
  lx_map = {
    for k, _ in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k], local.l3_map[k], local.l4_map[k])
  }
  output_data = {
    for k, v in local.lx_map : k => merge(
      {
        for k_attr, v_attr in v : k_attr => v_attr if !contains([], k_attr)
      },
      {
        cluster_arn             = aws_elasticache_cluster.this_cluster[k].arn
        cluster_cache_node_list = aws_elasticache_cluster.this_cluster[k].cache_nodes
        log                     = v.create_log_group ? module.log.data["cache_${k}"] : null
      }
    )
  }
}
