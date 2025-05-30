{{ name.map() }}

locals {
  create_cluster_map = {
    for k, v in local.lx_map : k => merge(v, {
      execute_command_log_group_name = module.log_group.data[v.k_log].log_group_name
    })
  }
  create_log_map = {
    for k, v in local.lx_map : v.k_log => merge(v, {
      log_retention_days = v.execute_command_log_retention_days
    })
  }
  create_provider_map = {
    for k, v in local.lx_map : k => merge(v, {
      cluster_name = aws_ecs_cluster.this_ecs_cluster[k].name
    })
  }
  l0_map = {
    for k, v in var.compute_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      capability_type                        = "FARGATE" # Consumed by ecs_task
      capacity_type                          = v.capacity_type == null ? var.compute_capacity_type_default : v.capacity_type
      execute_command_log_encryption_enabled = v.execute_command_log_encryption_enabled == null ? var.compute_execute_command_log_encryption_enabled_default : v.execute_command_log_encryption_enabled
      execute_command_log_retention_days     = v.execute_command_log_retention_days == null ? var.compute_execute_command_log_retention_days_default : v.execute_command_log_retention_days
      k_log                                  = "${k}_exec"
      kms_key_id_execute_command             = v.kms_key_id_execute_command == null ? var.compute_kms_key_id_execute_command_default : v.kms_key_id_execute_command
      service_connect_default_namespace      = v.service_connect_default_namespace == null ? var.compute_service_connect_default_namespace_default : v.service_connect_default_namespace
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
    }
  }
  lx_map = {
    for k, _ in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k])
  }
  output_data = {
    for k, v in local.lx_map : k => merge(
      {
        for k_attr, v_attr in v : k_attr => v_attr if !contains([], k_attr)
      },
      {
        capacity_provider_name = v.capacity_type
        ecs_cluster_arn        = aws_ecs_cluster.this_ecs_cluster[k].arn
        ecs_cluster_id         = aws_ecs_cluster.this_ecs_cluster[k].id
        log                    = module.log_group.data[v.k_log]
      }
    )
  }
}
