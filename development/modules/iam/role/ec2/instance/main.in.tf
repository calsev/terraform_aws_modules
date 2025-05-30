module "this_role" {
  source                   = "../../../../iam/role/base"
  assume_role_service_list = ["ec2"]
  create_instance_profile  = true
  embedded_role_policy_attach_arn_map = {
    read_ssm_cw_config_cpu = {
      policy = var.monitor_data.ecs_ssm_param_map.cpu.policy_map["read"].iam_policy_arn
    }
    read_ssm_cw_config_gpu = {
      policy = var.monitor_data.ecs_ssm_param_map.gpu.policy_map["read"].iam_policy_arn
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
  {{ name.map_item() }}
  {{ iam.role_map_item() }}
  std_map                              = var.std_map
}
