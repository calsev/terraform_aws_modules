resource "aws_ssm_parameter" "ssm_param_cw_config_cpu" {
  name = local.cw_config_name_cpu
  tags = merge(
    var.std_map.tags,
    {
      Name = local.cw_config_name_cpu
    }
  )
  type  = "String"
  value = jsonencode(local.cw_config_cpu)
}

resource "aws_ssm_parameter" "ssm_param_cw_config_gpu" {
  name = local.cw_config_name_gpu
  tags = merge(
    var.std_map.tags,
    {
      Name = local.cw_config_name_gpu
    }
  )
  type  = "String"
  value = jsonencode(local.cw_config_gpu)
}
