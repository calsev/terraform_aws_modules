resource "aws_ssm_parameter" "ssm_param_cw_config" {
  name = local.cw_config_name
  tags = merge(
    var.std_map.tags,
    {
      Name = local.cw_config_name
    }
  )
  type  = "String"
  value = file("${path.module}/cloudwatch_agent_config.json")
}
