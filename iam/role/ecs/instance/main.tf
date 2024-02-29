module "this_role" {
  source                   = "../../../../iam/role/base"
  assume_role_service_list = ["ec2"]
  create_instance_profile  = true
  embedded_role_policy_managed_name_map = {
    cloudwatch_agent = {
      policy = "CloudWatchAgentServerPolicy"
    }
    ecs_service = {
      policy = "service-role/AmazonEC2ContainerServiceforEC2Role"
    }
  }
  max_session_duration_m               = var.max_session_duration_m
  name                                 = "ecs_instance"
  name_prefix                          = var.name_prefix
  name_infix                           = var.name_infix
  role_policy_attach_arn_map_default   = var.policy_attach_arn_map
  role_policy_create_json_map_default  = var.policy_create_json_map
  role_policy_inline_json_map_default  = var.policy_inline_json_map
  role_policy_managed_name_map_default = var.policy_managed_name_map
  role_path                            = var.role_path
  std_map                              = var.std_map
}
