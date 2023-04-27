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
      arch                  = v.arch == null ? var.task_arch_default : v.arch
      ecs_cluster_arn       = v.ecs_cluster_arn == null ? var.task_ecs_cluster_arn_default : v.ecs_cluster_arn
      efs_volume_map        = v.efs_volume_map == null ? var.task_efs_volume_map_default : v.efs_volume_map
      iam_role_arn          = v.iam_role_arn == null ? var.task_iam_role_arn_default : v.iam_role_arn
      schedule_expression   = v.schedule_expression == null ? var.task_schedule_expression_default : v.schedule_expression
    })
  }
  t2_map = {
    for k, v in var.task_map : k => {
      alert_event_pattern_doc = {
        detail = {
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
      container_definition_list = [
        for def in v.container_definition_list : {
          command    = (def.command_join == null ? var.task_container_command_join_default : def.command_join) ? [join(" && ", def.command_list)] : def.command_list
          cpu        = 0
          entryPoint = def.entry_point == null ? var.task_container_entry_point_default : def.entry_point
          environment = [
            for k, v in merge(
              {
                AWS_DEFAULT_REGION = var.std_map.aws_region_name
              },
              def.environment_map == null ? {} : def.environment_map
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
          memoryReservation = (def.memory_reservation_gib == null ? var.task_container_memory_reservation_gib_default : def.memory_reservation_gib) * 1024
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
          volumesFrom = []
        }
      ]
      efs_volume_map = {
        for name, volume_data in local.t1_map[k].efs_volume_map : name => {
          efs_volume_configuration = {
            authorization_config = volume_data.root_directory != null ? null : volume_data.authorization_config != null ? {
              access_point_id = volume_data.authorization_config.access_point_id
              iam             = volume_data.authorization_config.iam != null ? volume_data.authorization_config.iam : var.task_efs_authorization_iam_default
              } : {
              access_point_id = null
              iam             = var.task_efs_authorization_iam_default
            }
            file_system_id     = volume_data.file_system_id
            root_directory     = volume_data.root_directory != null ? volume_data.root_directory : var.task_efs_root_directory_default
            transit_encryption = volume_data.transit_encryption != null ? volume_data.transit_encryption : var.task_efs_transit_encryption_default
          }
        }
      }
      k_alert = "${local.t1_map[k].name_simple}-failed"
    }
  }
  task_map = {
    for k, v in var.task_map : k => merge(local.t1_map[k], local.t2_map[k])
  }
}
