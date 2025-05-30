{{ name.map() }}

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
  l0_map = {
    for k, v in var.group_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], module.vpc_map.data[k], {
      auto_scaling_iam_role_arn_service_linked    = v.auto_scaling_iam_role_arn_service_linked == null ? var.group_auto_scaling_iam_role_arn_service_linked_default : v.auto_scaling_iam_role_arn_service_linked
      auto_scaling_num_instances_max              = v.auto_scaling_num_instances_max == null ? var.group_auto_scaling_num_instances_max_default : v.auto_scaling_num_instances_max
      auto_scaling_num_instances_min              = v.auto_scaling_num_instances_min == null ? var.group_auto_scaling_num_instances_min_default : v.auto_scaling_num_instances_min
      auto_scaling_protect_from_scale_in          = v.auto_scaling_protect_from_scale_in == null ? var.group_auto_scaling_protect_from_scale_in_default : v.auto_scaling_protect_from_scale_in
      elb_target_group_key_list                   = v.elb_target_group_key_list == null ? var.group_elb_target_group_key_list_default : v.elb_target_group_key_list
      health_check_type                           = v.health_check_type == null ? var.group_health_check_type_default : v.health_check_type
      instance_maintenance_max_healthy_percentage = v.instance_maintenance_max_healthy_percentage == null ? var.group_instance_maintenance_max_healthy_percentage_default : v.instance_maintenance_max_healthy_percentage
      instance_maintenance_min_healthy_percentage = v.instance_maintenance_min_healthy_percentage == null ? var.group_instance_maintenance_min_healthy_percentage_default : v.instance_maintenance_min_healthy_percentage
      launch_template_id                          = v.launch_template_id == null ? var.group_launch_template_id_default : v.launch_template_id
      placement_group_id                          = v.placement_group_id == null ? var.group_placement_group_id_default : v.placement_group_id
      suspended_processes                         = v.suspended_processes == null ? var.group_suspended_processes_default : v.suspended_processes
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      health_check_type    = local.l1_map[k].health_check_type == null ? length(local.l1_map[k].elb_target_group_key_list) == 0 ? "EC2" : "ELB" : local.l1_map[k].health_check_type
      resource_name_prefix = "${local.l1_map[k].name_effective}-"
      elb_target_group_arn_list = [
        for key in local.l1_map[k].elb_target_group_key_list : var.elb_target_data_map[key].target_group_arn
      ]
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
        auto_scaling_group_arn = aws_autoscaling_group.this_asg[k].arn
      }
    )
  }
}
