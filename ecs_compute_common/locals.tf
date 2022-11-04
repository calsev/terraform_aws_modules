locals {
  arch            = local.instance_family_to_arch[local.instance_family]
  instance_family = split(".", var.compute_environment.instance_type)[0]
  instance_family_to_arch = {
    a1   = "aarch64"
    g4dn = "x86_64"
    t3a  = "x86_64"
    t4g  = "aarch64"
    m5a  = "x86_64"
    p3   = "x86_64"
  }
  name                 = replace(var.name, "_", "-")
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
      ssm_param_name_cw_config = var.ssm_param_name_cw_config
      user_data_commands       = local.user_data_commands
    }
  )
  user_data_encoded  = base64encode(local.user_data)
  user_data_commands = var.compute_environment.user_data_commands != null ? var.compute_environment.user_data_commands : []
}
