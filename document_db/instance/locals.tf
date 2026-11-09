module "alarm_map" {
  source              = "../../cw/alarm_map"
  alarm_map           = var.instance_map
  alarm_map_default   = var.instance_alarm_map_default
  alert_level_default = var.alert_level_default
  monitor_data        = var.monitor_data
  name_map            = module.name_map.data
}

module "name_map" {
  source                          = "../../name_map"
  name_append_default             = var.name_append_default
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_map                        = local.l0_map
  name_prefix_default             = var.name_prefix_default
  name_prepend_default            = var.name_prepend_default
  name_regex_allow_list           = var.name_regex_allow_list
  name_suffix_default             = var.name_suffix_default
  std_map                         = var.std_map
}

locals {
  create_alarm_1_list = flatten([
    for k, v in local.lx_map : [
      for k_alarm, v_alarm in v.alarm_map : merge(v, v_alarm, {
        metric_dimension_map = {
          DBInstanceIdentifier = v.name_effective
        }
        k_all = "${k}_${k_alarm}"
      })
    ]
  ])
  create_alarm_x_map = {
    for v in local.create_alarm_1_list : v.k_all => v
  }
  l0_map = {
    for k, v in var.instance_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], module.alarm_map.data[k], {
      apply_immediately                = v.apply_immediately == null ? var.instance_apply_immediately_default : v.apply_immediately
      auto_minor_version_upgrade       = v.auto_minor_version_upgrade == null ? var.instance_auto_minor_version_upgrade_default : v.auto_minor_version_upgrade
      availability_zone_name           = v.availability_zone_name == null ? var.instance_availability_zone_name_default : v.availability_zone_name
      ca_cert_identifier               = v.ca_cert_identifier == null ? var.instance_ca_cert_identifier_default : v.ca_cert_identifier
      certificate_rotation_restart     = v.certificate_rotation_restart == null ? var.instance_certificate_rotation_restart_default : v.certificate_rotation_restart
      copy_tags_to_snapshot            = v.copy_tags_to_snapshot == null ? var.instance_copy_tags_to_snapshot_default : v.copy_tags_to_snapshot
      engine                           = v.engine == null ? var.instance_engine_default : v.engine
      instance_class                   = v.instance_class == null ? var.instance_class_default : v.instance_class
      maintenance_window_utc           = v.maintenance_window_utc == null ? var.instance_maintenance_window_utc_default : v.maintenance_window_utc
      performance_insights_enabled     = v.performance_insights_enabled == null ? var.instance_performance_insights_enabled_default : v.performance_insights_enabled
      performance_insights_kms_key_arn = v.performance_insights_kms_key_arn == null ? var.instance_performance_insights_kms_key_arn_default : v.performance_insights_kms_key_arn
      promotion_tier                   = v.promotion_tier == null ? var.instance_promotion_tier_default : v.promotion_tier
    })
  }
  lx_map = {
    for k, _ in local.l0_map : k => merge(local.l1_map[k])
  }
  output_data = {
    for k, v in local.lx_map : k => merge(
      v,
      {
        alarm = {
          for k_alarm, v_alarm in v.alarm_map : k_alarm => module.alarm.data["${k}_${k_alarm}"]
        }
        instance_arn             = aws_docdb_cluster_instance.this_instance[k].arn
        instance_dbi_resource_id = aws_docdb_cluster_instance.this_instance[k].dbi_resource_id
        instance_endpoint        = aws_docdb_cluster_instance.this_instance[k].endpoint
        instance_id              = aws_docdb_cluster_instance.this_instance[k].id
        instance_port            = aws_docdb_cluster_instance.this_instance[k].port
        instance_writer          = aws_docdb_cluster_instance.this_instance[k].writer
      },
    )
  }
}
