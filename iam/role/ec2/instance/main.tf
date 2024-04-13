module "this_role" {
  source                   = "../../../../iam/role/base"
  assume_role_service_list = ["ec2"]
  create_instance_profile  = true
  embedded_role_policy_attach_arn_map = {
    read_ssm_cw_config_cpu = {
      policy = var.monitor_data.ecs_ssm_param_map.cpu.iam_policy_arn_map["read"]
    }
    read_ssm_cw_config_gpu = {
      policy = var.monitor_data.ecs_ssm_param_map.gpu.iam_policy_arn_map["read"]
    }
  }
  embedded_role_policy_managed_name_map = {
    cloudwatch_agent = {
      policy = "CloudWatchAgentServerPolicy"
    }
  }
  map_policy                           = var.map_policy
  max_session_duration_m               = var.max_session_duration_m
  name                                 = var.name
  name_include_app_fields              = var.name_include_app_fields
  name_infix                           = var.name_infix
  name_prefix                          = var.name_prefix
  role_policy_attach_arn_map_default   = var.role_policy_attach_arn_map_default
  role_policy_create_json_map_default  = var.role_policy_create_json_map_default
  role_policy_inline_json_map_default  = var.role_policy_inline_json_map_default
  role_policy_managed_name_map_default = var.role_policy_managed_name_map_default
  role_path                            = var.role_path
  std_map                              = var.std_map
}
