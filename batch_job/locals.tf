module "name_map" {
  source   = "../name_map"
  name_map = var.job_map
  std_map  = var.std_map
}

locals {
  alert_map = {
    for k, v in local.job_map : k => v if v.alert_level != null
  }
  l1_map = {
    for k, v in var.job_map : k => merge(v, module.name_map.data[k], {
      alert_level = v.alert_level == null ? var.job_alert_level_default : v.alert_level
      alert_target_path_map = {
        job_id          = "$.detail.jobId"
        job_name        = "$.detail.jobName"
        aws_region_name = "$.region"
        reason          = "$.detail.statusReason"
      }
      alert_target_template      = <<-EOT
      {
        "Message": "Batch job '<job_name>' failed!",
        "Reason": "<reason>",
        "URL": "https://<aws_region_name>.console.aws.amazon.com/batch/home?region=<aws_region_name>#jobs/detail/<job_id>"
      }
      EOT
      command_list               = v.command_list == null ? var.job_command_list_default : v.command_list
      iam_role_arn_job_container = v.iam_role_arn_job_container == null ? var.job_iam_role_arn_job_container_default : v.iam_role_arn_job_container
      iam_role_arn_job_execution = v.iam_role_arn_job_execution == null ? var.job_iam_role_arn_job_execution_default : v.iam_role_arn_job_execution
      image_id                   = v.image_id == null ? var.job_image_id_default : v.image_id
      image_tag                  = v.image_tag == null ? var.job_image_tag_default : v.image_tag
      memory_gib                 = v.memory_gib == null ? var.job_memory_gib_default : v.memory_gib
      mount_map                  = v.mount_map == null ? var.job_mount_map_default : v.mount_map
      number_of_cpu              = v.number_of_cpu == null ? var.job_number_of_cpu_default : v.number_of_cpu
      number_of_gpu              = v.number_of_gpu == null ? var.job_number_of_gpu_default : v.number_of_gpu
      parameter_map              = v.parameter_map == null ? var.job_parameter_map_default : v.parameter_map
      shared_memory_gib          = v.shared_memory_gib == null ? var.job_shared_memory_gib_default : v.shared_memory_gib
      secret_map                 = v.secret_map == null ? var.job_secret_map_default : v.secret_map
      ulimit_map                 = v.ulimit_map == null ? var.job_ulimit_map_default : v.ulimit_map
    })
  }
  l2_map = {
    for k, v in var.job_map : k => {
      alert_event_pattern_doc = {
        detail = {
          jobDefinition = [
            {
              prefix = "arn:${var.std_map.iam_partition}:batch:${var.std_map.aws_region_name}:${var.std_map.aws_account_id}:job-definition/${local.l1_map[k].name_effective}:"
            }
          ]
          status = [
            "FAILED",
          ]
        }
        detail-type = [
          "Batch Job State Change",
        ]
        source = [
          "aws.batch",
        ]
      }
      k_alert = "${local.l1_map[k].name_simple}-failed"
      linux_param_map = {
        devices          = []
        sharedMemorySize = local.l1_map[k].shared_memory_gib * 1024
        tmpfs            = []
      }
      requirement_list_cpu = [
        {
          type  = "VCPU"
          value = tostring(local.l1_map[k].number_of_cpu)
        },
        {
          type  = "MEMORY"
          value = tostring(local.l1_map[k].memory_gib * 1024)
        },
      ]
      requirement_list_gpu = [
        {
          type  = "GPU"
          value = tostring(local.l1_map[k].number_of_gpu)
        }
      ]
    }
  }
  l3_map = {
    for k, v in var.job_map : k => {
      requirement_list = local.l1_map[k].number_of_gpu > 0 ? concat(local.l2_map[k].requirement_list_cpu, local.l2_map[k].requirement_list_gpu) : local.l2_map[k].requirement_list_cpu
    }
  }
  job_map = {
    for k, v in var.job_map : k => merge(local.l1_map[k], local.l2_map[k], local.l3_map[k])
  }
  output_data = {
    for k, v in local.job_map : k => merge(
      {
        for k_job, v_job in v : k_job => v_job if !contains(["requirement_list", "requirement_list_cpu", "requirement_list_gpu"], k_job)
      },
      {
        alert               = v.alert_level == null ? null : module.alert_trigger.data[v.k_alert]
        job_definition_arn  = aws_batch_job_definition.this_job[k].arn
        job_definition_name = aws_batch_job_definition.this_job[k].name
      }
    )
  }
}
