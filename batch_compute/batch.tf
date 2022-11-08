module "compute_common" {
  source                           = "../ecs_compute_common"
  compute_environment              = local.compute_environment
  iam_instance_profile_arn_for_ecs = var.iam_data.iam_instance_profile_arn_for_ecs
  name                             = var.name
  security_group_id_list           = var.security_group_id_list
  set_ecs_cluster_in_user_data     = false
  ssm_param_name_cw_config         = var.ssm_param_name_cw_config
  std_map                          = var.std_map
}

resource "aws_batch_compute_environment" "this_compute_env" {
  compute_environment_name_prefix = local.resource_name_prefix
  compute_resources {
    allocation_strategy = "BEST_FIT"
    bid_percentage      = 100 # Bid percentage set to 100 to maximize availability and minimize interruptions
    desired_vcpus       = local.compute_environment.min_vcpus
    ec2_configuration {
      image_type = local.image_type
    }
    instance_role = var.iam_data.iam_instance_profile_arn_for_ecs # ECS service API calls
    instance_type = [local.compute_environment.instance_type]
    launch_template {
      launch_template_id = module.compute_common.data.launch_template_id
      version            = module.compute_common.data.launch_template_version
    }
    max_vcpus           = local.compute_environment.max_vcpus
    min_vcpus           = local.compute_environment.min_vcpus
    security_group_ids  = var.security_group_id_list
    spot_iam_fleet_role = local.batch_is_spot ? var.iam_data.iam_role_arn_batch_spot_fleet : null
    subnets             = var.subnet_id_list
    tags                = local.tags
    type                = local.compute_environment.instance_allocation_type
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
  tags         = local.tags
  type         = "MANAGED"
}

resource "aws_batch_job_queue" "this_job_queue" {
  compute_environments = [
    aws_batch_compute_environment.this_compute_env.arn
  ]
  name     = local.resource_name
  priority = 1
  state    = "ENABLED"
  tags     = local.tags
}
