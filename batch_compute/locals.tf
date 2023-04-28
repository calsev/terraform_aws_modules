locals {
  compute_map = {
    for k, v in var.compute_map : k => merge(local.l1_map[k], local.l2_map[k])
  }
  l1_map = {
    for k, v in var.compute_map : k => merge(v, module.compute_common.data[k], {
      image_type    = module.compute_common.data[k].has_gpu ? "ECS_AL2_NVIDIA" : "ECS_AL2"
      max_instances = v.max_instances == null ? var.compute_max_instances_default : v.max_instances
      min_instances = v.min_instances == null ? var.compute_min_instances_default : v.min_instances
    })
  }
  l2_map = {
    for k, v in var.compute_map : k => {
      max_num_vcpu = local.l1_map[k].max_instances * local.l1_map[k].instance_type_num_vcpu
      min_num_vcpu = local.l1_map[k].min_instances * local.l1_map[k].instance_type_num_vcpu
    }
  }
  output_data = {
    for k, v in local.compute_map : k => merge(v, {
      batch_compute_environment_arn = aws_batch_compute_environment.this_compute_env[k].arn
      batch_job_queue_arn           = aws_batch_job_queue.this_job_queue[k].arn
    })
  }
}
