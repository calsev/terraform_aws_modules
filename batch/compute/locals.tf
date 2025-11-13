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
  vpc_az_key_list_default             = var.vpc_az_key_list_default
  vpc_data_map                        = var.vpc_data_map
  vpc_key_default                     = var.vpc_key_default
  vpc_map                             = local.l0_map
  vpc_security_group_key_list_default = var.vpc_security_group_key_list_default
  vpc_segment_key_default             = var.vpc_segment_key_default
}

locals {
  create_template_map = {
    for k, v in local.l1_map : k => v if v.instance_allocation_type != "FARGATE"
  }
  l0_map = {
    for k, v in var.compute_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], module.vpc_map.data[k], {
      instance_allocation_strategy   = v.instance_allocation_strategy == null ? var.compute_instance_allocation_strategy_default : v.instance_allocation_strategy
      instance_allocation_type       = v.instance_allocation_type == null ? var.compute_instance_allocation_type_default : v.instance_allocation_type
      max_instances                  = v.max_instances == null ? var.compute_max_instances_default : v.max_instances
      min_instances                  = v.min_instances == null ? var.compute_min_instances_default : v.min_instances
      placement_group_id             = v.placement_group_id == null ? var.compute_placement_group_id_default : v.placement_group_id
      update_job_termination_enabled = v.update_job_termination_enabled == null ? var.compute_update_job_termination_enabled_default : v.update_job_termination_enabled
      update_job_timeout_minutes     = v.update_job_timeout_minutes == null ? var.compute_update_job_timeout_minutes_default : v.update_job_timeout_minutes
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      image_type           = local.l1_map[k].instance_allocation_type == "FARGATE" ? null : module.compute_common.data[k].has_gpu ? "ECS_AL2_NVIDIA" : "ECS_AL2023"
      image_type_second    = local.l1_map[k].instance_allocation_type == "FARGATE" ? null : module.compute_common.data[k].has_gpu ? "ECS_AL2" : null # GPU envs have two compute configs
      resource_name_prefix = "${local.l1_map[k].name_effective}-"
      supports_update      = contains(["BEST_FIT_PROGRESSIVE", "SPOT_CAPACITY_OPTIMIZED"], local.l1_map[k].instance_allocation_strategy)
    }
  }
  l3_map = {
    for k, v in local.l0_map : k => {
      max_num_vcpu = local.l1_map[k].max_instances * (local.l1_map[k].instance_allocation_type == "FARGATE" ? 1 : module.compute_common.data[k].instance_type_num_vcpu)
      min_num_vcpu = local.l1_map[k].min_instances * (local.l1_map[k].instance_allocation_type == "FARGATE" ? 1 : module.compute_common.data[k].instance_type_num_vcpu)
    }
  }
  lx_map = {
    for k, v in local.l0_map : k => merge(
      local.l1_map[k],
      local.l1_map[k].instance_allocation_type == "FARGATE" ? null : module.compute_common.data[k],
      local.l2_map[k],
      local.l3_map[k],
    )
  }
  output_data = {
    for k, v in local.lx_map : k => merge(v, {
      batch_compute_environment_arn = aws_batch_compute_environment.this_compute_env[k].arn
      batch_job_queue_arn           = aws_batch_job_queue.this_job_queue[k].arn
    })
  }
}
