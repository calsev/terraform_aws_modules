locals {
  arch_map = {
    for k, v in var.compute_map : k => local.instance_family_to_arch[local.instance_family_map[k]]
  }
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
  instance_family_map = {
    for k, v in var.compute_map : k => split(".", v.instance_type)[0]
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
  is_gpu_map = {
    for k, v in var.compute_map : k => local.instance_family_is_gpu[local.instance_family_map[k]]
  }
  name_map = {
    for k, v in var.compute_map : k => replace(k, "/_/", "-")
  }
  compute_map = {
    for k, v in var.compute_map : k => merge(v, {
      arch                     = local.arch_map[k]
      image_id                 = v.image_id == null ? var.compute_image_id_default : v.image_id
      instance_allocation_type = v.instance_allocation_type == null ? var.compute_instance_allocation_type_default : v.instance_allocation_type
      instance_family          = local.instance_family_map[k]
      instance_storage_gib     = v.instance_storage_gib == null ? var.compute_instance_storage_gib_default : v.instance_storage_gib
      instance_type            = v.instance_type == null ? var.compute_instance_type_default : v.instance_type
      is_gpu                   = local.is_gpu_map[k]
      key_name                 = v.key_name == null ? var.compute_key_name_default : v.key_name
      name                     = local.name_map[k]
      resource_name            = local.resource_name_map[k]
      resource_name_prefix     = "${local.resource_name_map[k]}-"
      security_group_id_list   = v.security_group_id_list == null ? var.compute_security_group_id_list_default : v.security_group_id_list
      ssm_param_name_cw_config = local.ssm_param_name_cw_config_map[k]
      subnet_id_list           = v.subnet_id_list == null ? var.compute_subnet_id_list_default : v.subnet_id_list
      tags = merge(
        var.std_map.tags,
        {
          Name = local.resource_name_map[k]
        }
      )
      user_data_commands = v.user_data_commands == null ? var.compute_user_data_commands_default : v.user_data_commands
    })
  }
  output_data = {
    for k, v in local.compute_map : k => merge(v, {
      launch_template_id      = aws_launch_template.this_launch_template[k].id
      launch_template_version = aws_launch_template.this_launch_template[k].latest_version
      placement_group_id      = aws_placement_group.this_placement_group[k].id
    })
  }
  resource_name_map = {
    for k, v in var.compute_map : k => "${var.std_map.resource_name_prefix}${local.name_map[k]}${var.std_map.resource_name_suffix}"
  }
  ssm_param_name_cw_config_map = {
    for k, v in var.compute_map : k => var.cw_config_data.ecs.ssm_param_name[local.is_gpu_map[k] ? "gpu" : "cpu"]
  }
  user_data_map = {
    for k, v in var.compute_map : k => templatefile(
      "${path.module}/ec2_user_data.yml",
      {
        arch                     = local.arch_map[k]
        ecs_cluster_name         = var.set_ecs_cluster_in_user_data ? local.resource_name_map[k] : ""
        ssm_param_name_cw_config = local.ssm_param_name_cw_config_map[k]
        user_data_commands       = v.user_data_commands == null ? [] : v.user_data_commands
      }
    )
  }
  user_data_encoded_map = {
    for k, v in var.compute_map : k => base64encode(local.user_data_map[k])
  }
}
