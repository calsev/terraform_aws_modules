module "compute_common" {
  source                           = "../ecs_compute_common"
  compute_environment              = local.compute_environment
  iam_instance_profile_arn_for_ecs = var.iam_instance_profile_arn_for_ecs
  name                             = var.name
  security_group_id_list           = var.security_group_id_list
  set_ecs_cluster_in_user_data     = true
  ssm_param_name_cw_config         = var.ssm_param_name_cw_config
  std_map                          = var.std_map
}

resource "aws_autoscaling_group" "this_asg" {
  capacity_rebalance        = true
  default_cooldown          = 300
  desired_capacity          = local.compute_environment.min_instances
  health_check_grace_period = 300
  health_check_type         = "EC2"
  instance_refresh {
    strategy = "Rolling"
  }
  launch_template {
    id      = module.compute_common.data.launch_template_id
    version = "$Default"
  }
  lifecycle {
    # This is where ECS adds tags for managed ASG
    ignore_changes = [
      desired_capacity,
      tag,
    ]
  }
  name_prefix = local.resource_name_prefix
  # max_instance_lifetime
  max_size              = local.compute_environment.max_instances
  min_size              = local.compute_environment.min_instances
  placement_group       = module.compute_common.data.placement_group_id
  protect_from_scale_in = true
  # service_linked_role_arn
  # tags                 = [local.tags] # tags always show a change
  termination_policies = ["OldestLaunchConfiguration", "OldestInstance", "AllocationStrategy", "Default"]
  # target_group_arns
  vpc_zone_identifier       = var.subnet_id_list
  wait_for_capacity_timeout = "10m"
}
