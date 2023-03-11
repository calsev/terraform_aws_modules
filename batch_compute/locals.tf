locals {
  compute_map = {
    for k_comp, v in var.compute_map : k_comp => merge(v, module.compute_common.data[k_comp], {
      image_type = module.compute_common.data[k_comp].has_gpu ? "ECS_AL2_NVIDIA" : "ECS_AL2"
      max_vcpus  = v.max_vcpus == null ? var.compute_max_vcpus_default : v.max_vcpus
      min_vcpus  = v.min_vcpus == null ? var.compute_min_vcpus_default : v.min_vcpus
    })
  }
  output_data = {
    for k, v in local.compute_map : k => merge(v, {
      batch_compute_environment_arn = aws_batch_compute_environment.this_compute_env[k].arn
      batch_job_queue_arn           = aws_batch_job_queue.this_job_queue[k].arn
    })
  }
}
