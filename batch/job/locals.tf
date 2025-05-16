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

locals {
  create_job_map = {
    for k, v in local.lx_map : k => merge(v, {
      container_properties = merge(v.container_properties, {
        jobRoleArn = module.container_role[k].data.iam_role_arn
      })
    })
  }
  l0_map = {
    for k, v in var.job_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      alert_target_path_map = {
        job_id          = "$.detail.jobId"
        job_name        = "$.detail.jobName"
        aws_region_name = "$.region"
        reason          = "$.detail.statusReason"
      }
      alert_target_template = <<-EOT
      {
        "Message": "Batch job '<job_name>' failed!",
        "Reason": "<reason>",
        "URL": "https://<aws_region_name>.console.aws.amazon.com/batch/home?region=<aws_region_name>#jobs/detail/<job_id>"
      }
      EOT
      batch_cluster_key     = v.batch_cluster_key == null ? var.job_batch_cluster_key_default == null ? k : var.job_batch_cluster_key_default : v.batch_cluster_key
      command_list          = v.command_list == null ? var.job_command_list_default : v.command_list
      efs_volume_map        = v.efs_volume_map == null ? var.job_efs_volume_map_default : v.efs_volume_map
      entry_point           = v.entry_point == null ? var.job_entry_point_default : v.entry_point
      environment_map = merge(
        {
          AWS_DEFAULT_REGION = var.std_map.aws_region_name
        },
        v.environment_map == null ? var.job_environment_map_default : v.environment_map
      )
      host_volume_map            = v.host_volume_map == null ? var.job_host_volume_map_default : v.host_volume_map
      iam_role_arn_job_execution = v.iam_role_arn_job_execution == null ? var.job_iam_role_arn_job_execution_default == null ? var.iam_data.iam_role_arn_ecs_task_execution : var.job_iam_role_arn_job_execution_default : v.iam_role_arn_job_execution
      image_id                   = v.image_id == null ? var.job_image_id_default : v.image_id
      image_tag                  = v.image_tag == null ? var.job_image_tag_default : v.image_tag
      mount_map                  = v.mount_map == null ? var.job_mount_map_default : v.mount_map
      parameter_map              = v.parameter_map == null ? var.job_parameter_map_default : v.parameter_map
      privileged                 = v.privileged == null ? var.job_privileged_default : v.privileged
      resource_memory_shared_gib = v.resource_memory_shared_gib == null ? var.job_resource_memory_shared_gib_default : v.resource_memory_shared_gib
      secret_map                 = v.secret_map == null ? var.job_secret_map_default : v.secret_map
      ulimit_map                 = v.ulimit_map == null ? var.job_ulimit_map_default : v.ulimit_map
      username                   = v.username == null ? var.job_username_default : v.username
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      alert_event_pattern_json = jsonencode({
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
      })
      linux_param_map = {
        devices          = []
        sharedMemorySize = local.l1_map[k].resource_memory_shared_gib * 1024
        tmpfs            = []
      }
      efs_volume_map = {
        for k_vol, v_vol in local.l1_map[k].efs_volume_map : k_vol => merge(v_vol, {
          authorization_access_point_id = v_vol.authorization_access_point_id == null ? var.job_efs_authorization_access_point_id_default : v_vol.authorization_access_point_id
          authorization_iam_enabled     = v_vol.authorization_iam_enabled == null ? var.job_efs_authorization_iam_enabled_default : v_vol.authorization_iam_enabled
          file_system_id                = v_vol.file_system_id == null ? var.job_efs_file_system_id_default : v_vol.file_system_id
          transit_encryption_enabled    = v_vol.transit_encryption_enabled == null ? var.job_efs_transit_encryption_enabled_default : v_vol.transit_encryption_enabled
          transit_encryption_port       = v_vol.transit_encryption_port == null ? var.job_efs_transit_encryption_port_default : v_vol.transit_encryption_port
        })
      }
      mount_map = {
        for k_mount, v_mount in local.l1_map[k].mount_map : k_mount => merge(v_mount, {
          volume_key = v_mount.volume_key == null ? k_mount : v_mount.volume_key
        })
      }
      resource_memory_host_gib_default = 13 / 32 + var.batch_cluster_data[local.l1_map[k].batch_cluster_key].instance_type_memory_gib / 64
      resource_num_gpu_default         = var.batch_cluster_data[local.l1_map[k].batch_cluster_key].instance_type_num_gpu
      resource_num_vcpu_default        = var.batch_cluster_data[local.l1_map[k].batch_cluster_key].instance_type_num_vcpu
    }
  }
  l3_map = {
    for k, v in local.l0_map : k => {
      efs_volume_map = {
        for k_vol, v_vol in local.l2_map[k].efs_volume_map : k_vol => merge(v_vol, {
          root_directory = v_vol.authorization_access_point_id != null ? "/" : v_vol.root_directory == null ? var.job_efs_root_directory_default : v_vol.root_directory
        })
      }
      resource_memory_host_gib = v.resource_memory_host_gib == null ? var.job_resource_memory_host_gib_default == null ? local.l2_map[k].resource_memory_host_gib_default : var.job_resource_memory_host_gib_default : v.resource_memory_host_gib
      resource_num_gpu         = v.resource_num_gpu == null ? var.job_resource_num_gpu_default == null ? local.l2_map[k].resource_num_gpu_default : var.job_resource_num_gpu_default : v.resource_num_gpu
      resource_num_vcpu        = v.resource_num_vcpu == null ? var.job_resource_num_vcpu_default == null ? local.l2_map[k].resource_num_vcpu_default : var.job_resource_num_vcpu_default : v.resource_num_vcpu
    }
  }
  l4_map = {
    for k, v in local.l0_map : k => {
      requirement_list_gpu = [
        {
          type  = "GPU"
          value = tostring(local.l3_map[k].resource_num_gpu)
        }
      ]
      resource_memory_gib_default = var.batch_cluster_data[local.l1_map[k].batch_cluster_key].instance_type_memory_gib - local.l3_map[k].resource_memory_host_gib - local.l1_map[k].resource_memory_shared_gib
    }
  }
  l5_map = {
    for k, v in local.l0_map : k => {
      resource_memory_gib = v.resource_memory_gib == null ? var.job_resource_memory_gib_default == null ? local.l4_map[k].resource_memory_gib_default : var.job_resource_memory_gib_default : v.resource_memory_gib
    }
  }
  l6_map = {
    for k, v in local.l0_map : k => {
      requirement_list_cpu = [
        {
          type  = "VCPU"
          value = tostring(local.l3_map[k].resource_num_vcpu)
        },
        {
          type  = "MEMORY"
          value = tostring(local.l5_map[k].resource_memory_gib * 1024)
        },
      ]
    }
  }
  l7_map = {
    for k, v in local.l0_map : k => {
      requirement_list = local.l3_map[k].resource_num_gpu > 0 ? concat(local.l6_map[k].requirement_list_cpu, local.l4_map[k].requirement_list_gpu) : local.l6_map[k].requirement_list_cpu
    }
  }
  l8_map = {
    for k, v in local.l0_map : k => {
      container_properties = {
        # args does not work as advertised
        command = concat(local.l1_map[k].entry_point == null ? [] : local.l1_map[k].entry_point, local.l1_map[k].command_list)
        environment = [
          for k, v in local.l1_map[k].environment_map :
          {
            name  = k
            value = v
          }
        ]
        executionRoleArn = local.l1_map[k].iam_role_arn_job_execution
        image            = "${local.l1_map[k].image_id}:${local.l1_map[k].image_tag}"
        linuxParameters  = local.l2_map[k].linux_param_map
        mountPoints = [
          for k_mount, v_mount in local.l2_map[k].mount_map : {
            containerPath = v_mount.container_path
            readOnly      = v_mount.read_only
            sourceVolume  = v_mount.volume_key
          }
        ]
        privileged           = local.l1_map[k].privileged
        resourceRequirements = local.l7_map[k].requirement_list
        secrets = [
          for k, v in local.l1_map[k].secret_map : {
            name      = k
            valueFrom = v
          }
        ]
        ulimits = [
          for k, v in local.l1_map[k].ulimit_map : {
            hardLimit = v.hard_limit
            name      = k
            softLimit = v.soft_limit
          }
        ]
        user = local.l1_map[k].username
        volumes = concat(
          [
            for k_mount, v_mount in local.l1_map[k].host_volume_map : {
              host = {
                sourcePath = v_mount.host_path
              }
              name = k_mount
            }
          ],
          [
            for k_mount, v_mount in local.l3_map[k].efs_volume_map : {
              efsVolumeConfiguration = {
                authorizationConfig = {
                  accessPointId = v_mount.authorization_access_point_id
                  iam           = v_mount.authorization_iam_enabled ? "ENABLED" : "DISABLED"
                }
                fileSystemId          = v_mount.file_system_id
                rootDirectory         = v_mount.root_directory
                transitEncryption     = v_mount.transit_encryption_enabled ? "ENABLED" : "DISABLED"
                transitEncryptionPort = v_mount.transit_encryption_port
              }
              name = k_mount
            }
          ],
        )
      }
    }
  }
  lx_map = {
    for k, v in local.l0_map : k =>
    merge(local.l1_map[k], local.l2_map[k], local.l3_map[k], local.l4_map[k], local.l5_map[k], local.l6_map[k], local.l7_map[k], local.l8_map[k])
  }
  output_data = {
    for k, v in local.lx_map : k => merge(
      {
        for k_job, v_job in v : k_job => v_job
        if !contains(["alert_event_pattern_json", "requirement_list", "requirement_list_cpu", "requirement_list_gpu"], k_job)
      },
      {
        alert               = module.alert_trigger.data[k]
        job_definition_arn  = aws_batch_job_definition.this_job[k].arn
        job_definition_name = aws_batch_job_definition.this_job[k].name
        role                = module.container_role[k].data
      }
    )
  }
}
