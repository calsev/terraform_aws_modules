module "ssm_param_cw_config" {
  source = "../ssm_parameter_plain"
  param_map = {
    cloudwatch_agent_config_ecs_cpu = {
      insecure_value = jsonencode(local.cw_config_cpu)
    }
    cloudwatch_agent_config_ecs_gpu = {
      insecure_value = jsonencode(local.cw_config_gpu)
    }
  }
  std_map = var.std_map
}
