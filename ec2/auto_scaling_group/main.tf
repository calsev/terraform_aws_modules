resource "aws_autoscaling_group" "this_asg" {
  for_each                         = local.lx_map
  availability_zones               = null # Conflicts with vpc_zone_identifier
  capacity_rebalance               = true
  default_cooldown                 = 300
  default_instance_warmup          = 0
  desired_capacity                 = each.value.auto_scaling_num_instances_min
  desired_capacity_type            = null # Default "units" causes a dirty plan
  enabled_metrics                  = null # TODO
  force_delete                     = false
  force_delete_warm_pool           = false
  health_check_grace_period        = 300
  health_check_type                = "EC2" # TODO: ELB
  ignore_failed_scaling_activities = false
  # initial_lifecycle_hook # TODO
  # instance_maintenance_policy # TODO
  instance_refresh {
    preferences {
      auto_rollback                = false
      checkpoint_delay             = 3600
      checkpoint_percentages       = null
      instance_warmup              = null
      max_healthy_percentage       = 100
      min_healthy_percentage       = 90
      scale_in_protected_instances = "Ignore"
      skip_matching                = false
      standby_instances            = "Ignore"
    }
    strategy = "Rolling"
    triggers = []
  }
  launch_configuration = null # Conflicts with launch_template
  launch_template {
    id      = each.value.launch_template_id
    version = "$Default"
  }
  lifecycle {
    ignore_changes = [
      desired_capacity,
      tag, # This is where ECS adds tags for managed ASG
    ]
  }
  load_balancers        = null # Obsolete
  max_instance_lifetime = 0
  metrics_granularity   = "1Minute"
  min_elb_capacity      = null # TODO
  # mixed_instances_policy # Conflicts with launch_template
  name        = null                            # Conflicts with name_prefix
  name_prefix = each.value.resource_name_prefix # Name causes issues with replacing
  # max_instance_lifetime
  max_size                = each.value.auto_scaling_num_instances_max
  min_size                = each.value.auto_scaling_num_instances_min
  placement_group         = each.value.placement_group_id
  protect_from_scale_in   = each.value.auto_scaling_protect_from_scale_in
  service_linked_role_arn = each.value.auto_scaling_iam_role_arn_service_linked
  suspended_processes     = []
  dynamic "tag" {
    for_each = each.value.tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
  termination_policies = ["OldestLaunchConfiguration", "OldestInstance", "AllocationStrategy", "Default"]
  # target_group_arns # TODO
  # traffic_source # TODO
  vpc_zone_identifier       = each.value.vpc_subnet_id_list
  wait_for_capacity_timeout = "10m"
  wait_for_elb_capacity     = null # TODO
  # warm_pool # TODO
}
