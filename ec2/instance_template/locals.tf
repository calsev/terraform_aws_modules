module "name_map" {
  source   = "../../name_map"
  name_map = var.compute_map
  std_map  = var.std_map
}

locals {
  arch_instance_to_ami = {
    arm64  = "aarch64"
    x86_64 = "x86_64"
  }
  compute_map = {
    for k, v in var.compute_map : k => merge(local.l1_map[k], local.l2_map[k], local.l3_map[k], local.l4_map[k], local.l5_map[k], local.l6_map[k], local.l7_map[k])
  }
  l1_map = {
    for k, v in var.compute_map : k => merge(v, module.name_map.data[k], module.vpc_map.data[k], {
      iam_instance_profile_arn        = v.iam_instance_profile_arn == null ? var.compute_iam_instance_profile_arn_default : v.iam_instance_profile_arn
      image_id                        = v.image_id == null ? var.compute_image_id_default : v.image_id
      image_search_for_ecs            = v.image_search_for_ecs == null ? var.compute_image_search_for_ecs_default : v.image_search_for_ecs
      instance_allocation_type        = v.instance_allocation_type == null ? var.compute_instance_allocation_type_default : v.instance_allocation_type
      instance_storage_gib            = v.instance_storage_gib == null ? var.compute_instance_storage_gib_default : v.instance_storage_gib
      instance_type                   = v.instance_type == null ? var.compute_instance_type_default : v.instance_type
      key_name                        = v.key_name == null ? var.compute_key_name_default : v.key_name
      monitoring_advanced_enabled     = v.monitoring_advanced_enabled == null ? var.compute_monitoring_advanced_enabled_default : v.monitoring_advanced_enabled
      placement_partition_count       = v.placement_partition_count == null ? var.compute_placement_partition_count_default : v.placement_partition_count
      placement_spread_level          = v.placement_spread_level == null ? var.compute_placement_spread_level_default : v.placement_spread_level
      placement_strategy              = v.placement_strategy == null ? var.compute_placement_strategy_default : v.placement_strategy
      storage_volume_type             = v.storage_volume_type == null ? var.compute_storage_volume_type_default : v.storage_volume_type
      update_default_template_version = v.update_default_template_version == null ? var.compute_update_default_template_version_default : v.update_default_template_version
      user_data_commands              = v.user_data_commands == null ? var.compute_user_data_commands_default == null ? [] : var.compute_user_data_commands_default : v.user_data_commands
    })
  }
  l2_map = {
    for k, v in var.compute_map : k => {
      image_search_tag = local.l1_map[k].image_search_for_ecs ? "amazon" : v.image_search_tag == null ? var.compute_image_search_tag_default : v.image_search_tag
      instance_family  = split(".", local.l1_map[k].instance_type)[0]
    }
  }
  l3_map = {
    for k, v in var.compute_map : k => {
      arch                                         = local.arch_instance_to_ami[data.aws_ec2_instance_type.this_instance_type[k].supported_architectures[0]]
      cpu_credit_specification                     = data.aws_ec2_instance_type.this_instance_type[k].burstable_performance_supported ? "unlimited" : null
      has_gpu                                      = length(data.aws_ec2_instance_type.this_instance_type[k].gpus) > 0
      image_search_owner                           = var.image_search_tag_owner[local.l2_map[k].image_search_tag]
      instance_type_supported_architectures        = data.aws_ec2_instance_type.this_instance_type[k].supported_architectures
      instance_type_supported_root_device_types    = data.aws_ec2_instance_type.this_instance_type[k].supported_root_device_types
      instance_type_supported_virtualization_types = data.aws_ec2_instance_type.this_instance_type[k].supported_virtualization_types
      resource_name_prefix                         = "${local.l1_map[k].name_context}-"
    }
  }
  l4_map = {
    for k, v in var.compute_map : k => {
      image_search_name        = var.image_search_ecs_gpu_tag_name[local.l1_map[k].image_search_for_ecs][local.l3_map[k].has_gpu][local.l2_map[k].image_search_tag]
      ssm_param_name_cw_config = var.monitor_data.ecs_ssm_param_map[local.l3_map[k].has_gpu ? "gpu" : "cpu"].name_effective
    }
  }
  l5_map = {
    for k, v in var.compute_map : k => {
      image_id_default = data.aws_ami.this_default_ami[k].id
    }
  }
  l6_map = {
    for k, v in var.compute_map : k => {
      image_id = local.l1_map[k].image_id == null ? local.l5_map[k].image_id_default : local.l1_map[k].image_id
    }
  }
  l7_map = {
    for k, v in var.compute_map : k => {
      storage_root_device_name = data.aws_ami.this_ami[k].root_device_name
    }
  }
  output_data = {
    for k, v in local.compute_map : k => merge(v, {
      arch_image_default                 = data.aws_ami.this_default_ami[k].architecture
      image_name                         = data.aws_ami.this_ami[k].name
      image_name_default                 = data.aws_ami.this_default_ami[k].name
      instance_type_gpu_memory_total_gib = v.has_gpu ? data.aws_ec2_instance_type.this_instance_type[k].total_gpu_memory / 1024 : 0
      instance_type_num_gpu = v.has_gpu ? sum([
        for gpu in data.aws_ec2_instance_type.this_instance_type[k].gpus : gpu.count
      ]) : 0
      instance_type_memory_gib = data.aws_ec2_instance_type.this_instance_type[k].memory_size / 1024
      instance_type_num_vcpu   = data.aws_ec2_instance_type.this_instance_type[k].default_vcpus
      launch_template_id       = aws_launch_template.this_launch_template[k].id
      launch_template_version  = aws_launch_template.this_launch_template[k].latest_version
      placement_group_id       = aws_placement_group.this_placement_group[k].id
    })
  }
  user_data_map = {
    for k, v in var.compute_map : k => templatefile(
      "${path.module}/ec2_user_data.yml",
      {
        arch                     = local.l3_map[k].arch
        ecs_cluster_name         = var.set_ecs_cluster_in_user_data ? local.l1_map[k].name_effective : ""
        ssm_param_name_cw_config = local.l4_map[k].ssm_param_name_cw_config
        user_data_commands       = local.l1_map[k].user_data_commands
      }
    )
  }
  user_data_encoded_map = {
    for k, v in var.compute_map : k => base64encode(local.user_data_map[k])
  }
}
