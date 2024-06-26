module "compute_common" {
  source                                   = "../../ec2/instance_template"
  compute_iam_instance_profile_arn_default = var.iam_data.iam_instance_profile_arn_ecs
  compute_image_id_default                 = var.compute_image_id_default
  compute_image_search_for_ecs_default     = true
  compute_instance_allocation_type_default = var.compute_instance_allocation_type_default
  compute_instance_storage_gib_default     = var.compute_instance_storage_gib_default
  compute_instance_type_default            = var.compute_instance_type_default
  compute_key_pair_key_default             = var.compute_key_pair_key_default
  compute_map                              = local.lx_map
  compute_user_data_command_list_default   = var.compute_user_data_command_list_default
  iam_data                                 = var.iam_data
  monitor_data                             = var.monitor_data
  set_ecs_cluster_in_user_data             = true
  std_map                                  = var.std_map
  vpc_az_key_list_default                  = var.vpc_az_key_list_default
  vpc_key_default                          = var.vpc_key_default
  vpc_security_group_key_list_default      = var.vpc_security_group_key_list_default
  vpc_segment_key_default                  = var.vpc_segment_key_default
  vpc_data_map                             = var.vpc_data_map
}

module "asg" {
  source                                                 = "../../ec2/auto_scaling_group"
  group_auto_scaling_iam_role_arn_service_linked_default = var.compute_auto_scaling_iam_role_arn_service_linked_default
  group_auto_scaling_num_instances_max_default           = var.compute_auto_scaling_num_instances_max_default
  group_auto_scaling_num_instances_min_default           = var.compute_auto_scaling_num_instances_min_default
  group_auto_scaling_protect_from_scale_in_default       = var.compute_auto_scaling_protect_from_scale_in_default
  group_elb_target_group_key_list_default                = var.compute_elb_target_group_key_list_default
  group_health_check_type_default                        = var.compute_health_check_type_default
  group_map                                              = local.create_asg_map
  elb_target_data_map                                    = var.elb_target_data_map
  std_map                                                = var.std_map
  vpc_az_key_list_default                                = var.vpc_az_key_list_default
  vpc_data_map                                           = var.vpc_data_map
  vpc_key_default                                        = var.vpc_key_default
  vpc_security_group_key_list_default                    = var.vpc_security_group_key_list_default
  vpc_segment_key_default                                = var.vpc_segment_key_default
}

resource "aws_ecs_capacity_provider" "this_capacity_provider" {
  for_each = local.create_cp_map
  auto_scaling_group_provider {
    auto_scaling_group_arn = each.value.auto_scaling_group_arn
    managed_scaling {
      instance_warmup_period    = each.value.provider_instance_warmup_period_s
      maximum_scaling_step_size = each.value.provider_step_size_max
      minimum_scaling_step_size = each.value.provider_step_size_min
      status                    = each.value.provider_managed_scaling_enabled ? "ENABLED" : "DISABLED"
      target_capacity           = each.value.provider_target_capacity
    }
    managed_termination_protection = each.value.provider_managed_termination_protection ? "ENABLED" : "DISABLED"
  }
  name = each.value.name_effective
  tags = each.value.tags
}

module "log_group" {
  source = "../../cw/log_group"
  log_map = {
    for k, v in local.lx_map : v.k_log => v
  }
  policy_create_default = false
  std_map               = var.std_map
}

resource "aws_ecs_cluster" "this_ecs_cluster" {
  for_each = local.lx_map
  configuration {
    execute_command_configuration {
      #      kms_key_id = aws_kms_key.this_kms_key.arn
      log_configuration {
        cloud_watch_encryption_enabled = false # TODO
        cloud_watch_log_group_name     = module.log_group.data[each.value.k_log].log_group_name
        s3_bucket_encryption_enabled   = false # TODO
        s3_bucket_name                 = null  # TODO
        s3_key_prefix                  = null  # TODO
      }
      logging = "OVERRIDE"
    }
  }
  name = each.value.name_effective
  # service_connect_defaults # TODO
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
  tags = each.value.tags
}

resource "aws_ecs_cluster_capacity_providers" "this_capacity_provider" {
  for_each = local.lx_map
  capacity_providers = [
    aws_ecs_capacity_provider.this_capacity_provider[each.key].name
  ]
  cluster_name = aws_ecs_cluster.this_ecs_cluster[each.key].name
  default_capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.this_capacity_provider[each.key].name
    weight            = 100
  }
}
