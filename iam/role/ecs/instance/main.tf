module "this_role" {
  source                              = "../../../../iam/role/ec2/instance"
  max_session_duration_m              = var.max_session_duration_m
  monitor_data                        = var.monitor_data
  name                                = "ecs_instance"
  name_append_default                 = var.name_append_default
  name_include_app_fields_default     = var.name_include_app_fields_default
  name_infix_default                  = var.name_infix_default
  name_prefix_default                 = var.name_prefix_default
  name_prepend_default                = var.name_prepend_default
  name_suffix_default                 = var.name_suffix_default
  role_policy_attach_arn_map_default  = var.role_policy_attach_arn_map_default
  role_policy_create_json_map_default = var.role_policy_create_json_map_default
  role_policy_inline_json_map_default = var.role_policy_inline_json_map_default
  role_policy_managed_name_map_default = merge(
    {
      ecs_service = "service-role/AmazonEC2ContainerServiceforEC2Role"
    },
    var.role_policy_managed_name_map_default,
  )
  role_path_default = var.role_path_default
  std_map           = var.std_map
}
