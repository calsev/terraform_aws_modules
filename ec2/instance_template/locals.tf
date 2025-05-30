module "name_map" {
  source                          = "../../name_map"
  name_append_default             = var.name_append_default
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_map                        = local.l0_map
  name_prefix_default             = var.name_prefix_default
  name_prepend_default            = var.name_prepend_default
  name_regex_allow_list           = var.name_regex_allow_list
  name_suffix_default             = var.name_suffix_default
  std_map                         = var.std_map
}

module "vpc_map" {
  source                              = "../../vpc/id_map"
  vpc_map                             = local.l0_map
  vpc_az_key_list_default             = var.vpc_az_key_list_default
  vpc_key_default                     = var.vpc_key_default
  vpc_security_group_key_list_default = var.vpc_security_group_key_list_default
  vpc_segment_key_default             = var.vpc_segment_key_default
  vpc_data_map                        = var.vpc_data_map
}

locals {
  arch_instance_to_ami = {
    arm64  = "aarch64"
    x86_64 = "x86_64"
  }
  create_user_data_map = {
    for k, v in local.lx_map : k => v if !v.user_data_suppress_generation
  }
  l0_map = {
    for k, v in var.compute_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], module.vpc_map.data[k], {
      api_stop_disabled               = v.api_stop_disabled == null ? var.compute_api_stop_disabled_default : v.api_stop_disabled
      auto_recovery_enabled           = v.auto_recovery_enabled == null ? var.compute_auto_recovery_enabled_default : v.auto_recovery_enabled
      cpu_option_amd_sev_snp_enabled  = v.cpu_option_amd_sev_snp_enabled == null ? var.compute_cpu_option_amd_sev_snp_enabled_default : v.cpu_option_amd_sev_snp_enabled
      cpu_option_core_count           = v.cpu_option_core_count == null ? var.compute_cpu_option_core_count_default : v.cpu_option_core_count
      cpu_option_threads_per_core     = v.cpu_option_threads_per_core == null ? var.compute_cpu_option_threads_per_core_default : v.cpu_option_threads_per_core
      dns_private_aaaa_record_enabled = v.dns_private_aaaa_record_enabled == null ? var.compute_dns_private_aaaa_record_enabled_default : v.dns_private_aaaa_record_enabled
      dns_private_a_record_enabled    = v.dns_private_a_record_enabled == null ? var.compute_dns_private_a_record_enabled_default : v.dns_private_a_record_enabled
      dns_private_hostname_type       = v.dns_private_hostname_type == null ? var.compute_dns_private_hostname_type_default : v.dns_private_hostname_type
      ebs_optimized                   = v.ebs_optimized == null ? var.compute_ebs_optimized_default : v.ebs_optimized
      hibernation_enabled             = v.hibernation_enabled == null ? var.compute_hibernation_enabled_default : v.hibernation_enabled
      iam_instance_profile_arn        = v.iam_instance_profile_arn == null ? var.compute_iam_instance_profile_arn_default : v.iam_instance_profile_arn
      image_id                        = v.image_id == null ? var.compute_image_id_default : v.image_id
      image_search_for_ecs            = v.image_search_for_ecs == null ? var.compute_image_search_for_ecs_default : v.image_search_for_ecs
      instance_allocation_type        = v.instance_allocation_type == null ? var.compute_instance_allocation_type_default : v.instance_allocation_type
      instance_storage_gib            = v.instance_storage_gib == null ? var.compute_instance_storage_gib_default : v.instance_storage_gib
      instance_type                   = v.instance_type == null ? var.compute_instance_type_default : v.instance_type
      key_pair_key                    = v.key_pair_key == null ? var.compute_key_pair_key_default : v.key_pair_key
      metadata_endpoint_enabled       = v.metadata_endpoint_enabled == null ? var.compute_metadata_endpoint_enabled_default : v.metadata_endpoint_enabled
      metadata_version_2_required     = v.metadata_version_2_required == null ? var.compute_metadata_version_2_required_default : v.metadata_version_2_required
      metadata_ipv6_enabled           = v.metadata_ipv6_enabled == null ? var.compute_metadata_ipv6_enabled_default : v.metadata_ipv6_enabled
      metadata_response_hop_limit     = v.metadata_response_hop_limit == null ? var.compute_metadata_response_hop_limit_default : v.metadata_response_hop_limit
      metadata_tags_enabled           = v.metadata_tags_enabled == null ? var.compute_metadata_tags_enabled_default : v.metadata_tags_enabled
      monitoring_advanced_enabled     = v.monitoring_advanced_enabled == null ? var.compute_monitoring_advanced_enabled_default : v.monitoring_advanced_enabled
      nitro_enclaves_enabled          = v.nitro_enclaves_enabled == null ? var.compute_nitro_enclaves_enabled_default : v.nitro_enclaves_enabled
      placement_partition_count       = v.placement_partition_count == null ? var.compute_placement_partition_count_default : v.placement_partition_count
      placement_spread_level          = v.placement_spread_level == null ? var.compute_placement_spread_level_default : v.placement_spread_level
      placement_strategy              = v.placement_strategy == null ? var.compute_placement_strategy_default : v.placement_strategy
      storage_volume_encrypted        = v.storage_volume_encrypted == null ? var.instance_storage_volume_encrypted_default : v.storage_volume_encrypted
      storage_volume_type             = v.storage_volume_type == null ? var.compute_storage_volume_type_default : v.storage_volume_type
      update_default_template_version = v.update_default_template_version == null ? var.compute_update_default_template_version_default : v.update_default_template_version
      user_data_command_list          = v.user_data_command_list == null ? var.compute_user_data_command_list_default == null ? [] : var.compute_user_data_command_list_default : v.user_data_command_list
      user_data_file_map              = v.user_data_file_map == null ? var.compute_user_data_file_map_default : v.user_data_file_map
      user_data_suppress_generation   = v.user_data_suppress_generation == null ? var.compute_user_data_suppress_generation_default : v.user_data_suppress_generation
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      has_cpu_option       = local.l1_map[k].cpu_option_amd_sev_snp_enabled != null || local.l1_map[k].cpu_option_core_count != null || local.l1_map[k].cpu_option_threads_per_core != null
      image_search_tag     = local.l1_map[k].image_search_for_ecs ? "amazon" : v.image_search_tag == null ? var.compute_image_search_tag_default : v.image_search_tag
      instance_family      = split(".", local.l1_map[k].instance_type)[0]
      key_pair_name        = local.l1_map[k].key_pair_key == null ? null : var.iam_data.key_pair_map[local.l1_map[k].key_pair_key].key_pair_name
      resource_name_prefix = "${local.l1_map[k].name_effective}-"
    }
  }
  l3_map = {
    for k, v in local.l0_map : k => {
      arch                                         = local.arch_instance_to_ami[data.aws_ec2_instance_type.this_instance_type[k].supported_architectures[0]]
      cpu_credit_specification                     = data.aws_ec2_instance_type.this_instance_type[k].burstable_performance_supported ? "unlimited" : null
      has_gpu                                      = length(data.aws_ec2_instance_type.this_instance_type[k].gpus) > 0
      image_search_owner                           = var.image_search_tag_owner[local.l2_map[k].image_search_tag]
      instance_type_supported_architectures        = data.aws_ec2_instance_type.this_instance_type[k].supported_architectures
      instance_type_supported_root_device_types    = data.aws_ec2_instance_type.this_instance_type[k].supported_root_device_types
      instance_type_supported_virtualization_types = data.aws_ec2_instance_type.this_instance_type[k].supported_virtualization_types
    }
  }
  l4_map = {
    for k, v in local.l0_map : k => {
      image_search_name        = var.image_search_ecs_gpu_tag_name[local.l1_map[k].image_search_for_ecs][local.l3_map[k].has_gpu][local.l2_map[k].image_search_tag]
      ssm_param_name_cw_config = var.monitor_data.ecs_ssm_param_map[local.l3_map[k].has_gpu ? "gpu" : "cpu"].name_effective
    }
  }
  l5_map = {
    for k, v in local.l0_map : k => {
      image_id_default = data.aws_ami.this_default_ami[k].id
    }
  }
  l6_map = {
    for k, v in local.l0_map : k => {
      image_id = local.l1_map[k].image_id == null ? local.l5_map[k].image_id_default : local.l1_map[k].image_id
    }
  }
  l7_map = {
    for k, v in local.l0_map : k => {
      storage_root_device_name = data.aws_ami.this_ami[k].root_device_name
    }
  }
  lx_map = {
    for k, v in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k], local.l3_map[k], local.l4_map[k], local.l5_map[k], local.l6_map[k], local.l7_map[k])
  }
  output_data = {
    for k, v in local.lx_map : k => merge(
      {
        for k_attr, v_attr in v : k_attr => v_attr if !(v.user_data_suppress_generation && k_attr == "user_data_command_list") # Commands are often sensitive
      },
      {
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
      },
    )
  }
  user_data_map = {
    for k, v in local.lx_map : k => templatefile(
      "${path.module}/ec2_user_data.yml",
      {
        arch                     = v.arch
        aws_region_name          = var.std_map.aws_region_name
        ecs_cluster_name         = var.set_ecs_cluster_in_user_data ? v.name_effective : ""
        ssm_param_name_cw_config = v.ssm_param_name_cw_config
        user_data_command_list   = v.user_data_command_list
        user_data_file_map       = v.user_data_file_map
      }
    )
  }
  user_data_encoded_map = {
    for k, v in local.lx_map : k => base64encode(local.user_data_map[k])
  }
}
