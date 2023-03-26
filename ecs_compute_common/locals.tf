locals {
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
  compute_map = {
    for k, v in var.compute_map : k => merge(local.l1_map[k], local.l2_map[k], local.l3_map[k], local.l4_map[k])
  }
  l1_map = {
    for k, v in var.compute_map : k => merge(v, module.vpc_map.data[k], {
      image_id                 = v.image_id == null ? var.compute_image_id_default : v.image_id
      instance_allocation_type = v.instance_allocation_type == null ? var.compute_instance_allocation_type_default : v.instance_allocation_type
      instance_storage_gib     = v.instance_storage_gib == null ? var.compute_instance_storage_gib_default : v.instance_storage_gib
      instance_type            = v.instance_type == null ? var.compute_instance_type_default : v.instance_type
      key_name                 = v.key_name == null ? var.compute_key_name_default : v.key_name
      name                     = replace(k, "/_/", "-")
      user_data_commands       = v.user_data_commands == null ? var.compute_user_data_commands_default == null ? [] : var.compute_user_data_commands_default : v.user_data_commands
    })
  }
  l2_map = {
    for k, v in var.compute_map : k => {
      cpu_credit_specification = substr(local.l1_map[k].instance_type, 0, 1) == "t" ? "unlimited" : null
      instance_family          = split(".", local.l1_map[k].instance_type)[0]
      resource_name            = "${var.std_map.resource_name_prefix}${local.l1_map[k].name}${var.std_map.resource_name_suffix}"
    }
  }
  l3_map = {
    for k, v in var.compute_map : k => {
      arch                 = local.instance_family_to_arch[local.l2_map[k].instance_family]
      ecs_cluster_name     = local.l2_map[k].resource_name
      has_gpu              = local.instance_family_is_gpu[local.l2_map[k].instance_family]
      resource_name_prefix = "${local.l2_map[k].resource_name}-"
      tags = merge(
        var.std_map.tags,
        {
          Name = local.l2_map[k].resource_name
        }
      )
    }
  }
  l4_map = {
    for k, v in var.compute_map : k => {
      ssm_param_name_cw_config = var.cw_config_data.ecs.ssm_param_name[local.l3_map[k].has_gpu ? "gpu" : "cpu"]
    }
  }
  output_data = {
    for k, v in local.compute_map : k => merge(v, {
      launch_template_id      = aws_launch_template.this_launch_template[k].id
      launch_template_version = aws_launch_template.this_launch_template[k].latest_version
      placement_group_id      = aws_placement_group.this_placement_group[k].id
    })
  }
  user_data_map = {
    for k, v in var.compute_map : k => templatefile(
      "${path.module}/ec2_user_data.yml",
      {
        arch                     = local.l3_map[k].arch
        ecs_cluster_name         = var.set_ecs_cluster_in_user_data ? local.l3_map[k].ecs_cluster_name : ""
        ssm_param_name_cw_config = local.l4_map[k].ssm_param_name_cw_config
        user_data_commands       = local.l1_map[k].user_data_commands
      }
    )
  }
  user_data_encoded_map = {
    for k, v in var.compute_map : k => base64encode(local.user_data_map[k])
  }
}
