locals {
  c1_map = {
    for k, v in var.compute_map : k => merge(v, module.compute_common.data[k], {
      auto_scaling_instance_warmup_period_s       = v.auto_scaling_instance_warmup_period_s == null ? var.compute_auto_scaling_instance_warmup_period_s_default : v.auto_scaling_instance_warmup_period_s
      auto_scaling_managed_scaling_enabled        = v.auto_scaling_managed_scaling_enabled == null ? var.compute_auto_scaling_managed_scaling_enabled_default : v.auto_scaling_managed_scaling_enabled
      auto_scaling_managed_termination_protection = v.auto_scaling_managed_termination_protection == null ? var.compute_auto_scaling_managed_termination_protection_default : v.auto_scaling_managed_termination_protection
      auto_scaling_maximum_scaling_step_size      = v.auto_scaling_maximum_scaling_step_size == null ? var.compute_auto_scaling_maximum_scaling_step_size_default : v.auto_scaling_maximum_scaling_step_size
      auto_scaling_minimum_scaling_step_size      = v.auto_scaling_minimum_scaling_step_size == null ? var.compute_auto_scaling_minimum_scaling_step_size_default : v.auto_scaling_minimum_scaling_step_size
      auto_scaling_target_capacity                = v.auto_scaling_target_capacity == null ? var.compute_auto_scaling_target_capacity_default : v.auto_scaling_target_capacity
      capability_type                             = "EC2" # Consumed by ecs_task
      k_log                                       = "${k}_exec"
      log_retention_days                          = v.log_retention_days == null ? var.compute_log_retention_days_default : v.log_retention_days
      max_instances                               = v.max_instances == null ? var.compute_max_instances_default : v.max_instances
      min_instances                               = v.min_instances == null ? var.compute_min_instances_default : v.min_instances
    })
  }
  compute_map = {
    for k, v in var.compute_map : k => merge(local.c1_map[k])
  }
  output_data = {
    for k, v in local.compute_map : k => merge(v, {
      auto_scaling_group_arn = aws_autoscaling_group.this_asg[k].arn
      capacity_provider_name = aws_ecs_capacity_provider.this_capacity_provider[k].name
      ecs_cluster_arn        = aws_ecs_cluster.this_ecs_cluster[k].arn
      ecs_cluster_id         = aws_ecs_cluster.this_ecs_cluster[k].id
      log                    = module.log_group.data[v.k_log]
    })
  }
}