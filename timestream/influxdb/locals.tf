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
  vpc_az_key_list_default             = var.vpc_az_key_list_default
  vpc_data_map                        = var.vpc_data_map
  vpc_key_default                     = var.vpc_key_default
  vpc_map                             = local.l0_map
  vpc_security_group_key_list_default = var.vpc_security_group_key_list_default
  vpc_segment_key_default             = var.vpc_segment_key_default
}

locals {
  create_cluster_map = {
    for k, v in local.lx_map : k => v if v.is_cluster
  }
  create_instance_map = {
    for k, v in local.lx_map : k => v if !v.is_cluster
  }
  l0_map = {
    for k, v in var.db_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], module.vpc_map.data[k], {
      bucket_name             = v.bucket_name == null ? var.db_bucket_name_default : v.bucket_name
      cluster_failover_mode   = v.cluster_failover_mode == null ? var.db_cluster_failover_mode_default : v.cluster_failover_mode
      deployment_type         = v.deployment_type == null ? var.db_deployment_type_default : v.deployment_type
      instance_type           = v.instance_type == null ? var.db_instance_type_default : v.instance_type
      is_cluster              = v.is_cluster == null ? var.db_is_cluster_default : v.is_cluster
      log_s3_bucket_name      = v.log_s3_bucket_name == null ? var.db_log_s3_bucket_name_default : v.log_s3_bucket_name
      maintenance_timezone    = v.maintenance_timezone == null ? var.db_maintenance_timezone_default : v.maintenance_timezone
      maintenance_window      = v.maintenance_window == null ? var.db_maintenance_window_default : v.maintenance_window
      network_type            = v.network_type == null ? var.db_network_type_default : v.network_type
      organization            = v.organization == null ? var.db_organization_default : v.organization
      parameter_group_name    = v.parameter_group_name == null ? startswith(var.std_map.env, "pr") ? var.db_parameter_group_name_production_default : var.db_parameter_group_name_test_default : v.parameter_group_name
      port                    = v.port == null ? var.db_port_default : v.port
      publicly_access_enabled = v.publicly_access_enabled == null ? var.db_publicly_access_enabled_default : v.publicly_access_enabled
      storage_gib             = v.storage_gib == null ? var.db_storage_gib_default : v.storage_gib
      storage_type            = v.storage_type == null ? var.db_storage_type_default : v.storage_type
      username                = v.username == null ? var.db_username_default : v.username
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      has_parameter_group = local.l1_map[k].is_cluster && local.l1_map[k].parameter_group_name != null
    }
  }
  l3_map = {
    for k, v in local.l0_map : k => {
    }
  }
  lx_map = {
    for k, _ in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k], local.l3_map[k])
  }
  output_data = {
    for k, v in local.lx_map : k => merge(
      {
        for k_attr, v_attr in v : k_attr => v_attr if !contains([], k_attr)
      },
      {
        db_arn             = v.is_cluster ? aws_timestreaminfluxdb_db_cluster.this[k].arn : aws_timestreaminfluxdb_db_instance.this[k].arn
        db_endpoint        = v.is_cluster ? aws_timestreaminfluxdb_db_cluster.this[k].endpoint : aws_timestreaminfluxdb_db_instance.this[k].endpoint
        db_id              = v.is_cluster ? aws_timestreaminfluxdb_db_cluster.this[k].id : aws_timestreaminfluxdb_db_instance.this[k].id
        db_reader_endpoint = v.is_cluster ? aws_timestreaminfluxdb_db_cluster.this[k].reader_endpoint : null
        password           = v.is_cluster ? null : module.initial_password.data[k]
        secret_arn         = v.is_cluster ? aws_timestreaminfluxdb_db_cluster.this[k].influx_auth_parameters_secret_arn : aws_timestreaminfluxdb_db_instance.this[k].influx_auth_parameters_secret_arn
      },
    )
  }
}
