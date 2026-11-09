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

module "vpc_map" {
  source                              = "../../vpc/id_map"
  vpc_data_map                        = var.vpc_data_map
  vpc_key_default                     = var.vpc_key_default
  vpc_map                             = local.l0_map
  vpc_security_group_key_list_default = var.vpc_security_group_key_list_default
}

locals {
  create_instance_list = flatten([
    for k, v in local.lx_map : [
      for k_instance, v_instance in v.instance_map : {
        key = "${k}_${k_instance}"
        value = merge(v_instance, {
          cluster_identifier = aws_docdb_cluster.this_cluster[k].id
        })
      }
    ]
  ])
  create_instance_map = {
    for instance in local.create_instance_list : instance.key => instance.value
  }
  create_password_map = {
    for k, v in local.lx_map : k => merge(v, {
      name_append = v.password_secret_name_append
    })
  }
  l0_map = {
    for k, v in var.cluster_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], module.vpc_map.data[k], {
      allow_major_version_upgrade = v.allow_major_version_upgrade == null ? var.cluster_allow_major_version_upgrade_default : v.allow_major_version_upgrade
      apply_immediately           = v.apply_immediately == null ? var.cluster_apply_immediately_default : v.apply_immediately
      backup_retention_period_day = v.backup_retention_period_day == null ? var.cluster_backup_retention_period_day_default : v.backup_retention_period_day
      backup_window_utc           = v.backup_window_utc == null ? var.cluster_backup_window_utc_default : v.backup_window_utc
      cloudwatch_log_export_list  = v.cloudwatch_log_export_list == null ? var.cluster_cloudwatch_log_export_list_default : v.cloudwatch_log_export_list
      deletion_protection         = v.deletion_protection == null ? var.cluster_deletion_protection_default : v.deletion_protection
      engine                      = v.engine == null ? var.cluster_engine_default : v.engine
      engine_version              = v.engine_version == null ? var.cluster_engine_version_default : v.engine_version
      final_snapshot_enabled      = v.final_snapshot_enabled == null ? var.cluster_final_snapshot_enabled_default : v.final_snapshot_enabled
      instance_map                = v.instance_map == null ? var.cluster_instance_map_default : v.instance_map
      kms_key_id                  = v.kms_key_id == null ? var.cluster_kms_key_id_default : v.kms_key_id
      maintenance_window_utc      = v.maintenance_window_utc == null ? var.cluster_maintenance_window_utc_default : v.maintenance_window_utc
      network_type                = v.network_type == null ? var.cluster_network_type_default : v.network_type
      parameter_group_name        = v.parameter_group_name == null ? var.cluster_parameter_group_name_default : v.parameter_group_name
      password_secret_name_append = v.password_secret_name_append == null ? var.password_secret_name_append_default : v.password_secret_name_append
      port                        = v.port == null ? var.cluster_port_default : v.port
      secret_is_param             = v.secret_is_param == null ? var.cluster_secret_is_param_default : v.secret_is_param
      snapshot_identifier         = v.snapshot_identifier == null ? var.cluster_snapshot_identifier_default : v.snapshot_identifier
      storage_encrypted           = v.storage_encrypted == null ? var.cluster_storage_encrypted_default : v.storage_encrypted
      storage_type                = v.storage_type == null ? var.cluster_storage_type_default : v.storage_type
      subnet_group_name           = v.subnet_group_name == null ? var.cluster_subnet_group_name_default : v.subnet_group_name
      username                    = v.username == null ? var.cluster_username_default : v.username
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      final_snapshot_identifier = v.final_snapshot_identifier == null ? local.l1_map[k].name_effective : v.final_snapshot_identifier
      secret_random_init_map = {
        password = null
        username = local.l1_map[k].username
      }
    }
  }
  lx_map = {
    for k, v in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k])
  }
  output_data = {
    for k, v in local.lx_map : k => merge(
      v,
      module.password_secret.data[k],
      {
        cluster_arn             = aws_docdb_cluster.this_cluster[k].arn
        cluster_endpoint        = aws_docdb_cluster.this_cluster[k].endpoint
        cluster_id              = aws_docdb_cluster.this_cluster[k].id
        cluster_port            = aws_docdb_cluster.this_cluster[k].port
        cluster_reader_endpoint = aws_docdb_cluster.this_cluster[k].reader_endpoint
        cluster_resource_id     = aws_docdb_cluster.this_cluster[k].cluster_resource_id
        instance_map = {
          for k_instance, _ in v.instance_map : k_instance => module.instance.data["${k}_${k_instance}"]
        }
      },
    )
  }
}
