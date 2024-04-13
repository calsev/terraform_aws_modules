module "this_role" {
  source                 = "../../../../iam/role/ec2/instance"
  max_session_duration_m = var.max_session_duration_m
  monitor_data           = var.monitor_data
  name                   = "ecs_instance"
  name_prefix            = var.name_prefix
  name_infix             = var.name_infix
  role_policy_managed_name_map_default = {
    ecs_service = "service-role/AmazonEC2ContainerServiceforEC2Role"
  }
  role_path = var.role_path
  std_map   = var.std_map
}
