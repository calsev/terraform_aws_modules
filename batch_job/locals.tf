locals {
  cpu_requirement_map = {
    for k_job, v_job in var.job_map : k_job => [
      {
        type  = "VCPU"
        value = tostring(var.job_map[k_job].number_of_cpu)
      },
      {
        type  = "MEMORY"
        value = tostring(var.job_map[k_job].memory_gib * 1024)
      },
    ]
  }
  gpu_requirement_map = {
    for k_job, v_job in var.job_map : k_job => [
      {
        type  = "GPU"
        value = tostring(var.job_map[k_job].number_of_gpu)
      }
    ]
  }
  job_map = {
    for k_job, v_job in var.job_map : k_job => merge(v_job, {
      command_list               = v_job.command_list == null ? var.job_command_list_default : v_job.command_list
      iam_role_arn_job_container = v_job.iam_role_arn_job_container == null ? var.job_iam_role_arn_job_container_default : v_job.iam_role_arn_job_container
      iam_role_arn_job_execution = v_job.iam_role_arn_job_execution == null ? var.job_iam_role_arn_job_execution_default : v_job.iam_role_arn_job_execution
      image_id                   = v_job.image_id == null ? var.job_image_id_default : v_job.image_id
      image_tag                  = v_job.image_tag == null ? var.job_image_tag_default : v_job.image_tag
      memory_gib                 = v_job.memory_gib == null ? var.job_memory_gib_default : v_job.memory_gib
      number_of_cpu              = v_job.number_of_cpu == null ? var.job_number_of_cpu_default : v_job.number_of_cpu
      number_of_gpu              = v_job.number_of_gpu == null ? var.job_number_of_gpu_default : v_job.number_of_gpu
      shared_memory_gib          = local.shared_memory_map[k_job]
      tags                       = local.tag_map[k_job]
    })
  }
  linux_param_device_map = {
    devices = []
    tmpfs   = []
  }
  linux_param_map = {
    for k_job, v_mem in local.shared_memory_map : k_job => v_mem == null ? local.linux_param_device_map : merge(local.linux_param_device_map, {
      sharedMemorySize = v_mem * 1024
    })
  }
  output_data = {
    for k_job, v_job in local.job_map : k_job => merge(v_job, {
      job_definition_arn  = aws_batch_job_definition.this_job[k_job].arn
      job_definition_name = aws_batch_job_definition.this_job[k_job].name
    })
  }
  resource_name_map = {
    for k_job, v_job in var.job_map : k_job => "${var.std_map.resource_name_prefix}${replace(k_job, "/[_]/", "-")}${var.std_map.resource_name_suffix}"
  }
  resource_requirement_map = {
    for k_job, v_job in local.job_map : k_job => local.job_map[k_job].number_of_gpu > 0 ? concat(local.cpu_requirement_map[k_job], local.gpu_requirement_map[k_job]) : local.cpu_requirement_map[k_job]
  }
  shared_memory_map = {
    for k_job, v_job in var.job_map : k_job => v_job.shared_memory_gib == null ? var.job_shared_memory_gib_default : v_job.shared_memory_gib
  }
  tag_map = {
    for k_job, v_job in var.job_map : k_job => merge(
      var.std_map.tags,
      {
        Name = local.resource_name_map[k_job]
      }
    )
  }
}
