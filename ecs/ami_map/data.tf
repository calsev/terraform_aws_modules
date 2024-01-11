data "aws_ssm_parameter" "ecs_optimized_ami" {
  for_each = local.ami_tag_to_parameter_path
  name     = each.value
}
