locals {
  job_map = {
    for k_job, v_job in var.job_map : k_job => merge(v_job, local.requirement_map[k_job], {
      command_list               = v_job.command_list == null ? var.job_command_list_default : v_job.command_list
      iam_role_arn_job_container = v_job.iam_role_arn_job_container == null ? var.job_iam_role_arn_job_container_default : v_job.iam_role_arn_job_container
      iam_role_arn_job_execution = v_job.iam_role_arn_job_execution == null ? var.job_iam_role_arn_job_execution_default : v_job.iam_role_arn_job_execution
      image_id                   = v_job.image_id == null ? var.job_image_id_default : v_job.image_id
      image_tag                  = v_job.image_tag == null ? var.job_image_tag_default : v_job.image_tag
      mount_map                  = v_job.mount_map == null ? var.job_mount_map_default : v_job.mount_map
      name                       = local.resource_name_map[k_job]
      parameter_map              = v_job.parameter_map == null ? var.job_parameter_map_default : v_job.parameter_map
      secret_map                 = v_job.secret_map == null ? var.job_secret_map_default : v_job.secret_map
      tags = merge(
        var.std_map.tags,
        {
          Name = local.resource_name_map[k_job]
        }
      )
      ulimit_map = v_job.ulimit_map == null ? var.job_ulimit_map_default : v_job.ulimit_map
    })
  }
  linux_param_map = {
    for k_job, v_mem in local.requirement_map : k_job => {
      devices          = []
      sharedMemorySize = local.requirement_map[k_job].shared_memory_gib * 1024
      tmpfs            = []
    }
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
  requirement_list_cpu_map = {
    for k_job, v_job in var.job_map : k_job => [
      {
        type  = "VCPU"
        value = tostring(local.requirement_map[k_job].number_of_cpu)
      },
      {
        type  = "MEMORY"
        value = tostring(local.requirement_map[k_job].memory_gib * 1024)
      },
    ]
  }
  requirement_list_gpu_map = {
    for k_job, v_job in var.job_map : k_job => [
      {
        type  = "GPU"
        value = tostring(local.requirement_map[k_job].number_of_gpu)
      }
    ]
  }
  requirement_list_map = {
    for k_job, v_job in local.requirement_map : k_job => v_job.number_of_gpu > 0 ? concat(local.requirement_list_cpu_map[k_job], local.requirement_list_gpu_map[k_job]) : local.requirement_list_cpu_map[k_job]
  }
  requirement_map = {
    for k_job, v_job in var.job_map : k_job => {
      memory_gib        = v_job.memory_gib == null ? var.job_memory_gib_default : v_job.memory_gib
      number_of_cpu     = v_job.number_of_cpu == null ? var.job_number_of_cpu_default : v_job.number_of_cpu
      number_of_gpu     = v_job.number_of_gpu == null ? var.job_number_of_gpu_default : v_job.number_of_gpu
      shared_memory_gib = v_job.shared_memory_gib == null ? var.job_shared_memory_gib_default : v_job.shared_memory_gib
    }
  }
}
