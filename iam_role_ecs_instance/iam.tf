module "this_role" {
  source                   = "../iam_role"
  assume_role_service_list = ["ec2"]
  attach_policy_arn_map    = var.attach_policy_arn_map
  create_instance_profile  = true
  create_policy_json_map   = var.create_policy_json_map
  inline_policy_json_map   = var.inline_policy_json_map
  managed_policy_name_map = {
    cloudwatch_agent = "CloudWatchAgentServerPolicy"
    ecs_service      = "service-role/AmazonEC2ContainerServiceforEC2Role"
  }
  max_session_duration = var.max_session_duration
  name                 = "ecs_instance"
  name_prefix          = var.name_prefix
  name_infix           = var.name_infix
  role_path            = var.role_path
  std_map              = var.std_map
  tag                  = var.tag
}
