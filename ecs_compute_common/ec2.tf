module "vpc_map" {
  source                              = "../vpc_id_map"
  vpc_map                             = var.compute_map
  vpc_az_key_list_default             = var.vpc_az_key_list_default
  vpc_key_default                     = var.vpc_key_default
  vpc_security_group_key_list_default = var.vpc_security_group_key_list_default
  vpc_segment_key_default             = var.vpc_segment_key_default
  vpc_data_map                        = var.vpc_data_map
}

resource "aws_placement_group" "this_placement_group" {
  for_each     = local.compute_map
  name         = each.value.resource_name
  spread_level = "rack"
  strategy     = "spread"
  tags         = each.value.tags
}

resource "aws_launch_template" "this_launch_template" {
  for_each = local.compute_map
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      delete_on_termination = true
      volume_type           = "gp3"
      volume_size           = each.value.instance_storage_gib
    }
  }
  credit_specification {
    cpu_credits = each.value.cpu_credit_specification
  }
  # This role must have a policy to access the kms_key_id used to encrypt the EBS volume
  iam_instance_profile {
    arn = var.iam_instance_profile_arn_ecs
  }
  image_id      = each.value.image_id
  instance_type = each.value.instance_type
  key_name      = each.value.key_name
  monitoring {
    enabled = true
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
  update_default_version = true
  user_data              = local.user_data_encoded_map[each.key]
  vpc_security_group_ids = each.value.vpc_security_group_id_list
}

resource "local_file" "user_data" {
  for_each = local.compute_map
  content  = local.user_data_map[each.key]
  filename = "${path.root}/user_data/${replace(each.value.name, "/-/", "_")}_${var.std_map.config_name}.txt"
}
