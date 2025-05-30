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
  create_cp_map = {
    for k, v in local.lx_map : k => merge(v, {
      auto_scaling_group_arn = module.asg.data[k].auto_scaling_group_arn
    })
  }
  create_asg_map = {
    for k, v in local.lx_map : k => merge(v, {
      launch_template_id = module.compute_common.data[k].launch_template_id
      placement_group_id = module.compute_common.data[k].placement_group_id
    })
  }
  l0_map = {
    for k, v in var.compute_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      capability_type                         = "EC2" # Consumed by ecs_task
      k_log                                   = "${k}_exec"
      log_retention_days                      = v.log_retention_days == null ? var.compute_log_retention_days_default : v.log_retention_days
      provider_instance_warmup_period_s       = v.provider_instance_warmup_period_s == null ? var.compute_provider_instance_warmup_period_s_default : v.provider_instance_warmup_period_s
      provider_managed_scaling_enabled        = v.provider_managed_scaling_enabled == null ? var.compute_provider_managed_scaling_enabled_default : v.provider_managed_scaling_enabled
      provider_managed_termination_protection = v.provider_managed_termination_protection == null ? var.compute_provider_managed_termination_protection_default : v.provider_managed_termination_protection
      provider_step_size_max                  = v.provider_step_size_max == null ? var.compute_provider_step_size_max_default : v.provider_step_size_max
      provider_step_size_min                  = v.provider_step_size_min == null ? var.compute_provider_step_size_min_default : v.provider_step_size_min
      provider_target_capacity                = v.provider_target_capacity == null ? var.compute_provider_target_capacity_default : v.provider_target_capacity
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
    }
  }
  lx_map = {
    for k, v in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k])
  }
  output_data = {
    for k, v in local.lx_map : k => merge(
      {
        for k_attr, v_attr in v : k_attr => v_attr if !contains([], k_attr)
      },
      {
        auto_scaling_group     = module.asg.data[k]
        capacity_provider_name = aws_ecs_capacity_provider.this_capacity_provider[k].name
        ecs_cluster_arn        = aws_ecs_cluster.this_ecs_cluster[k].arn
        ecs_cluster_id         = aws_ecs_cluster.this_ecs_cluster[k].id
        instance_template      = module.compute_common.data[k]
        log                    = module.log_group.data[v.k_log]
      }
    )
  }
}
