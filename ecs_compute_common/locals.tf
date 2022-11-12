locals {
  arch                     = local.instance_family_to_arch[local.instance_family]
  ssm_param_name_cw_config = var.cw_config_data.ecs.ssm_param_name[local.is_gpu ? "gpu" : "cpu"]
  instance_family          = split(".", var.compute_environment.instance_type)[0]
  instance_family_is_gpu = {
    a1   = false
    c5   = false
    c5a  = false
    c6a  = false
    g4dn = true
    t3a  = false
    t4g  = false
    m5a  = false
    p3   = true
  }
  instance_family_to_arch = {
    a1   = "aarch64"
    c5   = "x86_64"
    c5a  = "x86_64"
    c6a  = "x86_64"
    g4dn = "x86_64"
    t3a  = "x86_64"
    t4g  = "aarch64"
    m5a  = "x86_64"
    p3   = "x86_64"
  }
  is_gpu = local.instance_family_is_gpu[local.instance_family]
  name   = replace(var.name, "_", "-")
  output_data = {
    arch                     = local.arch
    ssm_param_name_cw_config = local.ssm_param_name_cw_config
    instance_family          = local.instance_family
    is_gpu                   = local.is_gpu
    launch_template_id       = aws_launch_template.this_launch_template.id
    launch_template_version  = aws_launch_template.this_launch_template.latest_version
    placement_group_id       = aws_placement_group.this_placement_group.id
    user_data                = local.user_data
  }
  resource_name        = "${var.std_map.resource_name_prefix}${local.name}${var.std_map.resource_name_suffix}"
  resource_name_prefix = "${local.resource_name}-"
  tags = merge(
    var.std_map.tags,
    {
      Name = local.resource_name
    }
  )
  user_data = templatefile(
    "${path.module}/ec2_user_data.yml",
    {
      arch                     = local.arch
      ecs_cluster_name         = var.set_ecs_cluster_in_user_data ? local.resource_name : ""
      ssm_param_name_cw_config = local.ssm_param_name_cw_config
      user_data_commands       = local.user_data_commands
    }
  )
  user_data_encoded  = base64encode(local.user_data)
  user_data_commands = var.compute_environment.user_data_commands != null ? var.compute_environment.user_data_commands : []
}
