module "this_role" {
  source                   = "../../../../iam/role/base"
  assume_role_service_list = ["ec2"]
  create_instance_profile  = true
  max_session_duration_m   = var.max_session_duration_m
  name                     = "ecs_instance"
  name_prefix              = var.name_prefix
  name_infix               = var.name_infix
  policy_attach_arn_map    = var.policy_attach_arn_map
  policy_create_json_map   = var.policy_create_json_map
  policy_inline_json_map   = var.policy_inline_json_map
  policy_managed_name_map = {
    cloudwatch_agent = "CloudWatchAgentServerPolicy"
    ecs_service      = "service-role/AmazonEC2ContainerServiceforEC2Role"
  }
  role_path = var.role_path
  std_map   = var.std_map
  tag       = var.tag
}
