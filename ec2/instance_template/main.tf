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
      volume_type           = each.value.storage_volume_type
      volume_size           = each.value.instance_storage_gib
    }
  }
  credit_specification {
    cpu_credits = each.value.cpu_credit_specification
  }
  # This role must have a policy to access the kms_key_id used to encrypt the EBS volume
  dynamic "iam_instance_profile" {
    for_each = each.value.iam_instance_profile_arn == null ? {} : { this = {} }
    content {
      arn = each.value.iam_instance_profile_arn
    }
  }
  image_id      = each.value.image_id
  instance_type = each.value.instance_type
  key_name      = each.value.key_pair_name
  monitoring {
    enabled = each.value.monitoring_advanced_enabled
  }
  name_prefix = each.value.resource_name_prefix
  # network_interfaces
  placement {
    group_name = aws_placement_group.this_placement_group[each.key].name
  }
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
