module "name_map" {
  source                          = "../../name_map"
  name_include_app_fields_default = var.group_name_include_app_fields_default
  name_infix_default              = var.group_name_infix_default
  name_map                        = local.l0_map
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
  l0_map = {
    for k, v in var.group_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], module.vpc_map.data[k], {
      auto_scaling_iam_role_arn_service_linked = v.auto_scaling_iam_role_arn_service_linked == null ? var.group_auto_scaling_iam_role_arn_service_linked_default : v.auto_scaling_iam_role_arn_service_linked
      auto_scaling_num_instances_max           = v.auto_scaling_num_instances_max == null ? var.group_auto_scaling_num_instances_max_default : v.auto_scaling_num_instances_max
      auto_scaling_num_instances_min           = v.auto_scaling_num_instances_min == null ? var.group_auto_scaling_num_instances_min_default : v.auto_scaling_num_instances_min
      auto_scaling_protect_from_scale_in       = v.auto_scaling_protect_from_scale_in == null ? var.group_auto_scaling_protect_from_scale_in_default : v.auto_scaling_protect_from_scale_in
      placement_group_id                       = v.placement_group_id == null ? var.group_placement_group_id_default : v.placement_group_id
      launch_template_id                       = v.launch_template_id == null ? var.group_launch_template_id_default : v.launch_template_id
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      resource_name_prefix = "${local.l1_map[k].name_effective}-"
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
