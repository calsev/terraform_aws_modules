module "compute_common" {
  source                                   = "../../ec2_instance_template"
  compute_iam_instance_profile_arn_default = var.iam_data.iam_instance_profile_arn_ecs
  compute_image_id_default                 = var.compute_image_id_default
  compute_image_search_for_ecs_default     = true
  compute_instance_allocation_type_default = var.compute_instance_allocation_type_default
  compute_instance_storage_gib_default     = var.compute_instance_storage_gib_default
  compute_instance_type_default            = var.compute_instance_type_default
  compute_key_name_default                 = var.compute_key_name_default
  compute_map                              = var.compute_map
  compute_user_data_commands_default       = var.compute_user_data_commands_default
  monitor_data                             = var.monitor_data
  set_ecs_cluster_in_user_data             = true
  std_map                                  = var.std_map
  vpc_az_key_list_default                  = var.vpc_az_key_list_default
  vpc_key_default                          = var.vpc_key_default
  vpc_security_group_key_list_default      = var.vpc_security_group_key_list_default
  vpc_segment_key_default                  = var.vpc_segment_key_default
  vpc_data_map                             = var.vpc_data_map
}

resource "aws_autoscaling_group" "this_asg" {
  for_each                  = local.compute_map
  capacity_rebalance        = true
  default_cooldown          = 300
  desired_capacity          = each.value.min_instances
  health_check_grace_period = 300
  health_check_type         = "EC2"
  instance_refresh {
    strategy = "Rolling"
  }
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
  name_prefix = each.value.resource_name_prefix
  # max_instance_lifetime
  max_size              = each.value.max_instances
  min_size              = each.value.min_instances
  placement_group       = each.value.placement_group_id
  protect_from_scale_in = true
  # service_linked_role_arn
  dynamic "tag" {
    for_each = each.value.tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
  termination_policies = ["OldestLaunchConfiguration", "OldestInstance", "AllocationStrategy", "Default"]
  # target_group_arns
  vpc_zone_identifier       = each.value.vpc_subnet_id_list
  wait_for_capacity_timeout = "10m"
}