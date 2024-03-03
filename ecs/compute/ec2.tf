module "compute_common" {
  source                                   = "../../ec2/instance_template"
  compute_iam_instance_profile_arn_default = var.iam_data.iam_instance_profile_arn_ecs
  compute_image_id_default                 = var.compute_image_id_default
  compute_image_search_for_ecs_default     = true
  compute_instance_allocation_type_default = var.compute_instance_allocation_type_default
  compute_instance_storage_gib_default     = var.compute_instance_storage_gib_default
  compute_instance_type_default            = var.compute_instance_type_default
  compute_key_name_default                 = var.compute_key_name_default
  compute_map                              = local.lx_map
  compute_user_data_command_list_default   = var.compute_user_data_command_list_default
  monitor_data                             = var.monitor_data
  set_ecs_cluster_in_user_data             = true
  std_map                                  = var.std_map
  vpc_az_key_list_default                  = var.vpc_az_key_list_default
  vpc_key_default                          = var.vpc_key_default
  vpc_security_group_key_list_default      = var.vpc_security_group_key_list_default
  vpc_segment_key_default                  = var.vpc_segment_key_default
  vpc_data_map                             = var.vpc_data_map
}

module "asg" {
  source                                                 = "../../ec2/auto_scaling_group"
  group_auto_scaling_iam_role_arn_service_linked_default = var.compute_auto_scaling_iam_role_arn_service_linked_default
  group_auto_scaling_num_instances_max_default           = var.compute_auto_scaling_num_instances_max_default
  group_auto_scaling_num_instances_min_default           = var.compute_auto_scaling_num_instances_min_default
  group_auto_scaling_protect_from_scale_in_default       = var.compute_auto_scaling_protect_from_scale_in_default
  group_map                                              = local.create_asg_map
  std_map                                                = var.std_map
  vpc_az_key_list_default                                = var.vpc_az_key_list_default
  vpc_data_map                                           = var.vpc_data_map
  vpc_key_default                                        = var.vpc_key_default
  vpc_security_group_key_list_default                    = var.vpc_security_group_key_list_default
  vpc_segment_key_default                                = var.vpc_segment_key_default
}
