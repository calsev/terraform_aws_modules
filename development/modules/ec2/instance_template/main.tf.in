data "aws_ec2_instance_type" "this_instance_type" {
  for_each      = local.l1_map # NOT compute_map: we use the output very early
  instance_type = each.value.instance_type
}

data "aws_ami" "this_default_ami" {
  for_each = local.l3_map # NOT compute_map: we use the output very early
  filter {
    name   = "architecture"
    values = each.value.instance_type_supported_architectures
  }
  filter {
    name   = "name"
    values = [local.l4_map[each.key].image_search_name]
  }
  filter {
    name   = "root-device-type"
    values = each.value.instance_type_supported_root_device_types
  }
  filter {
    name   = "virtualization-type"
    values = each.value.instance_type_supported_virtualization_types
  }
  include_deprecated = false
  most_recent        = true
  owners             = [local.l3_map[each.key].image_search_owner]
}

data "aws_ami" "this_ami" {
  for_each = local.l6_map
  filter {
    name   = "image-id"
    values = [each.value.image_id]
  }
  owners = [local.l3_map[each.key].image_search_owner]
}

resource "aws_placement_group" "this_placement_group" {
  for_each        = local.lx_map
  name            = each.value.name_effective
  partition_count = each.value.placement_strategy == "partition" ? each.value.placement_partition_count : null
  spread_level    = each.value.placement_strategy == "spread" ? each.value.placement_spread_level : null
  strategy        = each.value.placement_strategy
  tags            = each.value.tags
}

resource "aws_launch_template" "this_launch_template" {
  for_each = local.lx_map
  block_device_mappings {
    device_name = each.value.storage_root_device_name
    ebs {
      delete_on_termination = true
      encrypted             = each.value.storage_volume_encrypted
      kms_key_id            = null # TODO
      snapshot_id           = null # TODO
      throughput            = null # TODO
      volume_type           = each.value.storage_volume_type
      volume_size           = each.value.instance_storage_gib
    }
    no_device    = false
    virtual_name = null # TODO
  }
  dynamic "block_device_mappings" {
    for_each = {} # TODO
    content {
      device_name = block_device_mappings.key
      ebs {
        delete_on_termination = block_device_mappings.delete_on_termination
        encrypted             = block_device_mappings.transit_encryption_enabled
        kms_key_id            = block_device_mappings.value.kms_key_id
        snapshot_id           = block_device_mappings.value.snapshot_id
        throughput            = block_device_mappings.value.gp3_provisioned_throughput
        volume_size           = block_device_mappings.value.size_gib
        volume_type           = block_device_mappings.value.volume_type
      }
      no_device    = block_device_mappings.value.block_device_mapping_disabled
      virtual_name = block_device_mappings.value.virtual_name
    }
  }
  capacity_reservation_specification {
    capacity_reservation_preference = "none" # TODO
    dynamic "capacity_reservation_target" {
      for_each = {}
      content {
        capacity_reservation_id                 = each.value.capacity_reservation_id
        capacity_reservation_resource_group_arn = each.value.capacity_reservation_resource_group_arn
      }
    }
  }
  dynamic "cpu_options" {
    for_each = each.value.has_cpu_option ? { this = {} } : {}
    content {
      amd_sev_snp      = each.value.cpu_option_amd_sev_snp_enabled == null ? null : each.value.cpu_option_amd_sev_snp_enabled ? "enabled" : "disabled"
      core_count       = each.value.cpu_option_core_count
      threads_per_core = each.value.cpu_option_threads_per_core
    }
  }
  credit_specification {
    cpu_credits = each.value.cpu_credit_specification
  }
  default_version  = null
  disable_api_stop = each.value.api_stop_disabled
  ebs_optimized    = each.value.ebs_optimized
  enclave_options {
    enabled = each.value.nitro_enclaves_enabled
  }
  hibernation_options {
    configured = each.value.hibernation_enabled
  }
  # This role must have a policy to access the kms_key_id used to encrypt the EBS volume
  dynamic "iam_instance_profile" {
    for_each = each.value.iam_instance_profile_arn == null ? {} : { this = {} }
    content {
      arn  = each.value.iam_instance_profile_arn
      name = null
    }
  }
  image_id                             = each.value.image_id
  instance_initiated_shutdown_behavior = "stop" # TODO
  dynamic "instance_market_options" {
    for_each = {} # TODO
    content {
      market_type = null
      spot_options {
        block_duration_minutes         = null
        instance_interruption_behavior = null
        max_price                      = null
        spot_instance_type             = null
        valid_until                    = null
      }
    }
  }
  dynamic "instance_requirements" {
    # Conflicts with instance_type
    for_each = each.value.instance_type == null ? { this = {} } : {}
    content {
      accelerator_count {
        max = null # REQ
        min = null
      }
      accelerator_manufacturers = [] # REQ
      accelerator_names         = [] # REQ
      accelerator_total_memory_mib {
        max = null # REQ
        min = null
      }
      accelerator_types      = []   # REQ
      allowed_instance_types = []   # REQ
      bare_metal             = null # REQ
      baseline_ebs_bandwidth_mbps {
        max = null # REQ
        min = null
      }
      burstable_performance   = null # REQ
      cpu_manufacturers       = []   # REQ
      excluded_instance_types = []   # REQ
      instance_generations    = []   # REQ
      local_storage           = null # REQ
      local_storage_types     = []   # REQ
      memory_gib_per_vcpu {
        max = null # REQ
        min = null
      }
      memory_mib {
        max = null # REQ
        min = null
      }
      network_bandwidth_gbps {
        max = null # REQ
        min = null
      }
      network_interface_count {
        max = null # REQ
        min = null
      }
      on_demand_max_price_percentage_over_lowest_price = null # REQ
      require_hibernate_support                        = null # REQ
      spot_max_price_percentage_over_lowest_price      = null # REQ
      total_local_storage_gb {
        max = null
        min = null
      }
      vcpu_count {
        max = null # REQ
        min = null
      }
    }
  }
  instance_type = each.value.instance_type
  key_name      = each.value.key_pair_name
  dynamic "license_specification" {
    for_each = {} # TODO
    content {
      license_configuration_arn = null
    }
  }
  maintenance_options {
    auto_recovery = each.value.auto_recovery_enabled ? "default" : "disabled"
  }
  metadata_options {
    http_endpoint               = each.value.metadata_endpoint_enabled ? "enabled" : "disabled"
    http_tokens                 = each.value.metadata_version_2_required ? "required" : "optional"
    http_protocol_ipv6          = each.value.metadata_ipv6_enabled ? "enabled" : "disabled"
    http_put_response_hop_limit = each.value.metadata_response_hop_limit
    instance_metadata_tags      = each.value.metadata_tags_enabled ? "enabled" : "disabled"
  }
  monitoring {
    enabled = each.value.monitoring_advanced_enabled
  }
  name        = null # Conflicts with name_prefix
  name_prefix = each.value.resource_name_prefix
  # network_interfaces # TODO
  placement {
    affinity                = null # PLACE
    availability_zone       = null # PLACE
    group_name              = aws_placement_group.this_placement_group[each.key].name
    host_id                 = null      # PLACE
    host_resource_group_arn = null      # PLACE
    spread_domain           = null      # PLACE
    tenancy                 = "default" # PLACE
    partition_number        = null      # PLACE
  }
  private_dns_name_options {
    enable_resource_name_dns_aaaa_record = each.value.dns_private_aaaa_record_enabled
    enable_resource_name_dns_a_record    = each.value.dns_private_a_record_enabled
    hostname_type                        = each.value.dns_private_hostname_type
  }
  ram_disk_id          = null # TODO
  security_group_names = null # Classic, use vpc_security_group_ids
  tag_specifications {
    resource_type = "instance"
    tags          = each.value.tags
  }
  tag_specifications {
    resource_type = "network-interface"
    tags          = each.value.tags
  }
  tag_specifications {
    resource_type = "volume"
    tags          = each.value.tags
  }
  tags                   = each.value.tags
  update_default_version = each.value.update_default_template_version
  user_data              = local.user_data_encoded_map[each.key]
  vpc_security_group_ids = each.value.vpc_security_group_id_list
}

resource "local_file" "user_data" {
  # Not sensitive because it is useful to see the diff of the rendered template
  for_each        = local.create_user_data_map
  content         = local.user_data_map[each.key]
  filename        = "${path.root}/user_data/${replace(each.value.name_simple, "/-/", "_")}_${var.std_map.config_name}.txt"
  file_permission = "0644"
}
