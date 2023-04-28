module "compute_common" {
  source                                   = "../ec2_instance_template"
  compute_iam_instance_profile_arn_default = var.iam_data.iam_instance_profile_arn_ecs
  compute_image_id_default                 = var.compute_image_id_default
  compute_image_search_for_ecs_default     = true
  compute_instance_allocation_type_default = var.compute_instance_allocation_type_default
  compute_instance_storage_gib_default     = var.compute_instance_storage_gib_default
  compute_instance_type_default            = var.compute_instance_type_default
  compute_key_name_default                 = var.compute_key_name_default
  compute_map                              = var.compute_map
  compute_user_data_commands_default       = var.compute_user_data_commands_default
  cw_config_data                           = var.cw_config_data
  set_ecs_cluster_in_user_data             = false
  std_map                                  = var.std_map
  vpc_az_key_list_default                  = var.vpc_az_key_list_default
  vpc_key_default                          = var.vpc_key_default
  vpc_security_group_key_list_default      = var.vpc_security_group_key_list_default
  vpc_segment_key_default                  = var.vpc_segment_key_default
  vpc_data_map                             = var.vpc_data_map
}

resource "aws_batch_compute_environment" "this_compute_env" {
  for_each                        = local.compute_map
  compute_environment_name_prefix = each.value.resource_name_prefix
  compute_resources {
    allocation_strategy = "BEST_FIT"
    bid_percentage      = 100 # Bid percentage set to 100 to maximize availability and minimize interruptions
    desired_vcpus       = each.value.min_num_vcpu
    ec2_configuration {
      image_id_override = each.value.image_id # Cleanup diff
      image_type        = each.value.image_type
    }
    instance_role = var.iam_data.iam_instance_profile_arn_ecs # ECS service API calls
    instance_type = [each.value.instance_type]
    launch_template {
      launch_template_id = each.value.launch_template_id
      version            = each.value.launch_template_version
    }
    max_vcpus           = each.value.max_num_vcpu
    min_vcpus           = each.value.min_num_vcpu
    security_group_ids  = each.value.vpc_security_group_id_list
    spot_iam_fleet_role = each.value.instance_allocation_type == "SPOT" ? var.iam_data.iam_role_arn_batch_spot_fleet : null
    subnets             = each.value.vpc_subnet_id_list
    tags                = each.value.tags
    type                = each.value.instance_allocation_type
  }
  lifecycle {
    # https://github.com/terraform-providers/terraform-provider-aws/issues/11077#issuecomment-560416740
    create_before_destroy = true
    # Ignore managed changes to desired vCPUs
    ignore_changes = [
      compute_resources[0].desired_vcpus
    ]
  }
  service_role = var.iam_data.iam_role_arn_batch_service # Batch service API calls
  tags         = each.value.tags
  type         = "MANAGED"
}

resource "aws_batch_job_queue" "this_job_queue" {
  for_each = local.compute_map
  compute_environments = [
    aws_batch_compute_environment.this_compute_env[each.key].arn
  ]
  name     = each.value.name_effective
  priority = 1
  state    = "ENABLED"
  tags     = each.value.tags
}
