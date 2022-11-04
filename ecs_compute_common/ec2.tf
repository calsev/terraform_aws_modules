resource "aws_placement_group" "this_placement_group" {
  name         = local.resource_name
  spread_level = "rack"
  strategy     = "spread"
  tags         = local.tags
}

resource "aws_launch_template" "this_launch_template" {
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      delete_on_termination = true
      volume_type           = "gp3"
      volume_size           = var.compute_environment.instance_storage_gib
    }
  }
  credit_specification {
    cpu_credits = substr(var.compute_environment.instance_type, 0, 1) == "t" ? "unlimited" : null
  }
  # This role must have a policy to access the kms_key_id used to encrypt the EBS volume
  iam_instance_profile {
    arn = var.iam_instance_profile_arn_for_ecs
  }
  image_id      = var.compute_environment.image_id
  instance_type = var.compute_environment.instance_type
  key_name      = var.compute_environment.key_name
  monitoring {
    enabled = true
  }
  name_prefix = local.resource_name_prefix
  # network_interfaces
  placement {
    group_name = aws_placement_group.this_placement_group.name
  }
  tag_specifications {
    resource_type = "instance"
    tags          = local.tags
  }
  tag_specifications {
    resource_type = "network-interface"
    tags          = local.tags
  }
  tag_specifications {
    resource_type = "volume"
    tags          = local.tags
  }
  tags                   = local.tags
  update_default_version = true
  user_data              = local.user_data_encoded
  vpc_security_group_ids = var.security_group_id_list
}
