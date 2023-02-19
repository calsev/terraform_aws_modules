module "compute_common" {
  source                                   = "../ecs_compute_common"
  compute_map                              = var.compute_map
  compute_image_id_default                 = var.compute_image_id_default
  compute_instance_allocation_type_default = var.compute_instance_allocation_type_default
  compute_instance_storage_gib_default     = var.compute_instance_storage_gib_default
  compute_instance_type_default            = var.compute_instance_type_default
  compute_key_name_default                 = var.compute_key_name_default
  compute_security_group_id_list_default   = var.compute_security_group_id_list_default
  compute_subnet_id_list_default           = var.compute_subnet_id_list_default
  compute_user_data_commands_default       = var.compute_user_data_commands_default
  cw_config_data                           = var.cw_config_data
  iam_instance_profile_arn_for_ecs         = var.iam_data.iam_instance_profile_arn_for_ecs
  set_ecs_cluster_in_user_data             = false
  std_map                                  = var.std_map
}

resource "aws_batch_compute_environment" "this_compute_env" {
  for_each                        = local.compute_map
  compute_environment_name_prefix = each.value.resource_name_prefix
  compute_resources {
    allocation_strategy = "BEST_FIT"
    bid_percentage      = 100 # Bid percentage set to 100 to maximize availability and minimize interruptions
    desired_vcpus       = each.value.min_vcpus
    ec2_configuration {
      image_type = each.value.image_type
    }
    instance_role = var.iam_data.iam_instance_profile_arn_for_ecs # ECS service API calls
    instance_type = [each.value.instance_type]
    launch_template {
      launch_template_id = each.value.launch_template_id
      version            = each.value.launch_template_version
    }
    max_vcpus           = each.value.max_vcpus
    min_vcpus           = each.value.min_vcpus
    security_group_ids  = each.value.security_group_id_list
    spot_iam_fleet_role = each.value.instance_allocation_type == "SPOT" ? var.iam_data.iam_role_arn_batch_spot_fleet : null
    subnets             = each.value.subnet_id_list
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
  name     = each.value.resource_name
  priority = 1
  state    = "ENABLED"
  tags     = each.value.tags
}
