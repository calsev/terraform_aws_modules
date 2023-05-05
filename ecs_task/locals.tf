module "name_map" {
  source   = "../name_map"
  name_map = var.task_map
  std_map  = var.std_map
}

locals {
  alert_map = {
    for k, v in local.task_map : k => v if v.alert_level != null
  }
  bus_map = {
    for k, v in local.task_map : k => v if v.schedule_expression != null # TODO: Other event types
  }
  o1_map = {
    for k, v in var.task_map : k => {
      task_def_arn_split             = split(":", aws_ecs_task_definition.this_task[k].arn) # Get rid of version number at end
      task_definition_arn_latest_rev = aws_ecs_task_definition.this_task[k].arn
    }
  }
  o2_map = {
    for k, v in var.task_map : k => {
      task_definition_arn_latest = join(":", slice(local.o1_map[k].task_def_arn_split, 0, length(local.o1_map[k].task_def_arn_split) - 1))
    }
  }
  output_data = {
    for k, v in local.task_map : k => merge(
      v,
      {
        for k_o, v_o in local.o1_map[k] : k_o => v_o if !contains(["task_def_arn_split"], k_o)
      },
      local.o2_map[k],
      {
        iam_role_arn = v.iam_role_arn
      },
    )
  }
  t1_map = {
    for k, v in var.task_map : k => merge(v, module.name_map.data[k], {
      alert_level = v.alert_level == null ? var.task_alert_level_default : v.alert_level
      alert_target_path_map = {
        aws_region_name = "$.region"
        cluster_id      = "$.detail.capacityProviderName"
        code            = "$.detail.stopCode"
        reason          = "$.detail.stoppedReason"
        task_name       = "$.detail.group"
      }
      alert_target_template = <<-EOT
      {
        "Message": "ECS task '<task_name>' failed!",
        "Reason": "<reason>",
        "Code": "<code>",
        "URL": "https://<aws_region_name>.console.aws.amazon.com/ecs/v2/clusters/<cluster_id>/tasks"
      }
      EOT
      ecs_cluster_key       = v.ecs_cluster_key == null ? var.task_ecs_cluster_key_default == null ? k : var.task_ecs_cluster_key_default : v.ecs_cluster_key
      efs_volume_map        = v.efs_volume_map == null ? var.task_efs_volume_map_default : v.efs_volume_map
      iam_role_arn          = v.iam_role_arn == null ? var.task_iam_role_arn_default : v.iam_role_arn
      network_mode          = v.network_mode == null ? var.task_network_mode_default : v.network_mode
      schedule_expression   = v.schedule_expression == null ? var.task_schedule_expression_default : v.schedule_expression
    })
  }
  t2_map = {
    for k, v in var.task_map : k => {
      alert_event_pattern_doc = {
        detail = {
          containers = {
            exitCode = [
              {
                anything-but = [
                  0,
                ]
              }
            ]
          }
          lastStatus = [
            "STOPPED",
          ]
          stoppedReason = [
            "Essential container in task exited"
          ]
          taskDefinitionArn = [
            {
              prefix = "arn:${var.std_map.iam_partition}:ecs:${var.std_map.aws_region_name}:${var.std_map.aws_account_id}:task-definition/${local.t1_map[k].name_effective}:"
            }
          ]
        }
        detail-type = [
          "ECS Task State Change",
        ]
        source = [
          "aws.ecs",
        ]
      }
      capability_type = var.ecs_cluster_data[local.t1_map[k].ecs_cluster_key].capability_type
      ecs_cluster_arn = var.ecs_cluster_data[local.t1_map[k].ecs_cluster_key].ecs_cluster_arn
      efs_volume_map = {
        for name, volume_data in local.t1_map[k].efs_volume_map : name => merge(volume_data, {
          authorization_access_point_id = volume_data.authorization_access_point_id == null ? var.task_efs_authorization_access_point_id_default : volume_data.authorization_access_point_id
          authorization_iam_enabled     = volume_data.authorization_iam_enabled == null ? var.task_efs_authorization_iam_enabled_default : volume_data.authorization_iam_enabled
          file_system_id                = volume_data.file_system_id
          transit_encryption_enabled    = volume_data.transit_encryption_enabled == null ? var.task_efs_transit_encryption_enabled_default : volume_data.transit_encryption_enabled
          transit_encryption_port       = volume_data.transit_encryption_port == null ? var.task_efs_transit_encryption_port_default : volume_data.transit_encryption_port
        })
      }
      k_alert = "${local.t1_map[k].name_simple}-failed"
    }
  }
  t3_map = {
    for k, v in var.task_map : k => {
      efs_volume_map = {
        for name, volume_data in local.t2_map[k].efs_volume_map : name => merge(volume_data, {
          root_directory = volume_data.authorization_access_point_id != null ? "/" : volume_data.root_directory == null ? var.task_efs_root_directory_default : volume_data.root_directory
        })
      }
      resource_memory_host_gib_default = local.t2_map[k].capability_type == "FARGATE" ? null : 13 / 32 + var.ecs_cluster_data[local.t1_map[k].ecs_cluster_key].instance_type_memory_gib / 64
      resource_num_vcpu_default        = local.t2_map[k].capability_type == "FARGATE" ? null : var.ecs_cluster_data[local.t1_map[k].ecs_cluster_key].instance_type_num_vcpu
    }
  }
  t4_map = {
    for k, v in var.task_map : k => {
      resource_memory_host_gib = local.t2_map[k].capability_type == "FARGATE" ? null : v.resource_memory_host_gib == null ? var.task_resource_memory_host_gib_default == null ? local.t3_map[k].resource_memory_host_gib_default : var.task_resource_memory_host_gib_default : v.resource_memory_host_gib
      resource_num_vcpu        = v.resource_num_vcpu == null ? var.task_resource_num_vcpu_default == null ? local.t3_map[k].resource_num_vcpu_default : var.task_resource_num_vcpu_default : v.resource_num_vcpu
    }
  }
  t5_map = {
    for k, v in var.task_map : k => {
      resource_memory_gib_default = local.t2_map[k].capability_type == "FARGATE" ? null : var.ecs_cluster_data[local.t1_map[k].ecs_cluster_key].instance_type_memory_gib - local.t4_map[k].resource_memory_host_gib
    }
  }
  t6_map = {
    for k, v in var.task_map : k => {
      resource_memory_gib = v.resource_memory_gib == null ? var.task_resource_memory_gib_default == null ? local.t5_map[k].resource_memory_gib_default : var.task_resource_memory_gib_default : v.resource_memory_gib
    }
  }
  t7_map = {
    for k, v in var.task_map : k => {
      container_definition_list = [
        for def in v.container_definition_list : {
          command = def.command_list == null ? null : (def.command_join == null ? var.task_container_command_join_default : def.command_join) ? [
            join(" && ", def.command_list)
          ] : def.command_list
          cpu        = (def.reserved_num_vcpu == null ? var.task_container_reserved_num_vcpu_default == null ? local.t4_map[k].resource_num_vcpu / length(v.container_definition_list) : var.task_container_reserved_num_vcpu_default : def.reserved_num_vcpu) * 1024
          entryPoint = def.entry_point == null ? var.task_container_entry_point_default : def.entry_point
          environment = [
            for k, v in merge(
              {
                AWS_DEFAULT_REGION = var.std_map.aws_region_name
              },
              def.environment_map == null ? var.task_container_environment_map_default : def.environment_map
              ) : {
              name  = k
              value = v
            }
          ]
          essential = true
          image     = def.image != null ? def.image : var.task_container_image_default
          linuxParameters = {
            initProcessEnabled = true
          }
          logConfiguration = {
            logDriver = "awslogs"
            options = {
              awslogs-group         = v.log_group_name == null ? var.task_log_group_name_default : v.log_group_name
              awslogs-region        = var.std_map.aws_region_name
              awslogs-stream-prefix = local.t1_map[k].name_context
            }
          }
          memoryReservation = (def.reserved_memory_gib == null ? var.task_container_reserved_memory_gib_default == null ? local.t6_map[k].resource_memory_gib / length(v.container_definition_list) : var.task_container_reserved_memory_gib_default : def.reserved_memory_gib) * 1024
          mountPoints = def.mount_point_map == null ? [] : [
            for name, mount_data in def.mount_point_map : {
              containerPath = mount_data.container_path
              readOnly      = mount_data.read_only != null ? mount_data.read_only : var.task_container_mount_read_only_default
              sourceVolume  = name
            }
          ]
          name = def.name
          portMappings = [
            for port_map in def.port_map_list != null ? def.port_map_list : [] : {
              containerPort = port_map.container_port
              hostPort      = port_map.host_port != null ? port_map.host_port : port_map.container_port
              protocol      = port_map.protocol != null ? port_map.protocol : var.task_container_port_protocol_default
            }
          ]
          secrets = [
            for k_secret, v_secret in def.secret_map == null ? var.task_container_secret_map_default : def.secret_map :
            {
              name      = k_secret
              valueFrom = v_secret
            }
          ]
          volumesFrom = []
        }
      ]
    }
  }
  task_map = {
    for k, v in var.task_map : k =>
    merge(local.t1_map[k], local.t2_map[k], local.t3_map[k], local.t4_map[k], local.t5_map[k], local.t6_map[k], local.t7_map[k])
  }
}
