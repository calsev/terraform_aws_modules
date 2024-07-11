module "name_map" {
  source   = "../../name_map"
  name_map = local.l0_map
  std_map  = var.std_map
}

locals {
  create_bus_map = {
    for k, v in local.lx_map : k => v if v.schedule_expression != null # TODO: Other event types
  }
  l0_map = {
    for k, v in var.task_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      alert_target_path_map = {
        aws_region_name = "$.region"
        cluster_id      = "$.detail.capacityProviderName"
        code            = "$.detail.stopCode"
        reason          = "$.detail.stoppedReason"
        task_name       = "$.detail.group"
      }
      alert_target_template  = <<-EOT
      {
        "Message": "ECS task '<task_name>' failed!",
        "Reason": "<reason>",
        "Code": "<code>",
        "URL": "https://<aws_region_name>.console.aws.amazon.com/ecs/v2/clusters/<cluster_id>/tasks"
      }
      EOT
      docker_volume_map      = v.docker_volume_map == null ? var.task_docker_volume_map_default : v.docker_volume_map
      ecs_cluster_key        = v.ecs_cluster_key == null ? var.task_ecs_cluster_key_default == null ? k : var.task_ecs_cluster_key_default : v.ecs_cluster_key
      efs_volume_map         = v.efs_volume_map == null ? var.task_efs_volume_map_default : v.efs_volume_map
      iam_role_arn_execution = v.iam_role_arn_execution == null ? var.task_iam_role_arn_execution_default == null ? var.iam_data.iam_role_arn_ecs_task_execution : var.task_iam_role_arn_execution_default : v.iam_role_arn_execution
      network_mode           = v.network_mode == null ? var.task_network_mode_default : v.network_mode
      schedule_expression    = v.schedule_expression == null ? var.task_schedule_expression_default : v.schedule_expression
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      alert_event_pattern_json = jsonencode({
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
              prefix = "arn:${var.std_map.iam_partition}:ecs:${var.std_map.aws_region_name}:${var.std_map.aws_account_id}:task-definition/${local.l1_map[k].name_effective}:"
            }
          ]
        }
        detail-type = [
          "ECS Task State Change",
        ]
        source = [
          "aws.ecs",
        ]
      })
      capability_type = var.ecs_cluster_data[local.l1_map[k].ecs_cluster_key].capability_type
      docker_volume_map = {
        for k_vol, v_vol in local.l1_map[k].docker_volume_map : k_vol => merge(v_vol, {
          driver            = v_vol.driver == null ? var.task_docker_volume_driver_default : v_vol.driver
          driver_option_map = v_vol.driver_option_map == null ? var.task_docker_volume_driver_option_map_default : v_vol.driver_option_map
          label_map         = v_vol.label_map == null ? var.task_docker_volume_label_map_default : v_vol.label_map
          scope             = v_vol.scope == null ? var.task_docker_volume_scope_default : v_vol.scope
        })
      }
      ecs_cluster_arn = var.ecs_cluster_data[local.l1_map[k].ecs_cluster_key].ecs_cluster_arn
      efs_volume_map = {
        for name, volume_data in local.l1_map[k].efs_volume_map : name => merge(volume_data, {
          authorization_access_point_id = volume_data.authorization_access_point_id == null ? var.task_efs_authorization_access_point_id_default : volume_data.authorization_access_point_id
          authorization_iam_enabled     = volume_data.authorization_iam_enabled == null ? var.task_efs_authorization_iam_enabled_default : volume_data.authorization_iam_enabled
          file_system_id                = volume_data.file_system_id
          transit_encryption_enabled    = volume_data.transit_encryption_enabled == null ? var.task_efs_transit_encryption_enabled_default : volume_data.transit_encryption_enabled
          transit_encryption_port       = volume_data.transit_encryption_port == null ? var.task_efs_transit_encryption_port_default : volume_data.transit_encryption_port
        })
      }
    }
  }
  l3_map = {
    for k, v in local.l0_map : k => {
      docker_volume_map = {
        for k_vol, v_vol in local.l2_map[k].docker_volume_map : k_vol => merge(v_vol, {
          auto_provision_enabled = v_vol.scope == "shared" ? v_vol.auto_provision_enabled == null ? var.task_docker_volume_auto_provision_enabled_default : v_vol.auto_provision_enabled : null
        })
      }
      efs_volume_map = {
        for name, volume_data in local.l2_map[k].efs_volume_map : name => merge(volume_data, {
          root_directory = volume_data.authorization_access_point_id != null ? "/" : volume_data.root_directory == null ? var.task_efs_root_directory_default : volume_data.root_directory
        })
      }
      resource_instance_type_memory_gib = local.l2_map[k].capability_type == "FARGATE" ? null : var.ecs_cluster_data[local.l1_map[k].ecs_cluster_key].instance_template.instance_type_memory_gib
      resource_num_vcpu_default         = local.l2_map[k].capability_type == "FARGATE" ? null : var.ecs_cluster_data[local.l1_map[k].ecs_cluster_key].instance_template.instance_type_num_vcpu
    }
  }
  l4_map = {
    for k, v in local.l0_map : k => {
      # This is fit on max(host memory for t4g, t3a, m7a) for all instance sizes 0.5 to 768 GiB with a slack of at least 20 MiB.
      resource_memory_host_gib_default = local.l2_map[k].capability_type == "FARGATE" ? null : ceil(92 + 0.063 * local.l3_map[k].resource_instance_type_memory_gib * 1024 + -0.000000022 * pow(local.l3_map[k].resource_instance_type_memory_gib * 1024, 2)) / 1024
      resource_num_vcpu                = v.resource_num_vcpu == null ? var.task_resource_num_vcpu_default == null ? local.l3_map[k].resource_num_vcpu_default : var.task_resource_num_vcpu_default : v.resource_num_vcpu
    }
  }
  l5_map = {
    for k, v in local.l0_map : k => {
      resource_memory_host_gib = local.l2_map[k].capability_type == "FARGATE" ? null : v.resource_memory_host_gib == null ? var.task_resource_memory_host_gib_default == null ? local.l4_map[k].resource_memory_host_gib_default : var.task_resource_memory_host_gib_default : v.resource_memory_host_gib
    }
  }
  l6_map = {
    for k, v in local.l0_map : k => {
      resource_memory_gib_default = local.l2_map[k].capability_type == "FARGATE" ? null : var.ecs_cluster_data[local.l1_map[k].ecs_cluster_key].instance_template.instance_type_memory_gib - local.l5_map[k].resource_memory_host_gib
    }
  }
  l7_map = {
    for k, v in local.l0_map : k => {
      resource_memory_gib = v.resource_memory_gib == null ? var.task_resource_memory_gib_default == null ? local.l6_map[k].resource_memory_gib_default : var.task_resource_memory_gib_default : v.resource_memory_gib
    }
  }
  l8_map = {
    for k, v in local.l0_map : k => {
      container_definition_list = [
        for k_def, v_def in v.container_definition_map : {
          command = v_def.command_list == null ? null : (v_def.command_join == null ? var.task_container_command_join_default : v_def.command_join) ? [
            join(" && ", v_def.command_list)
          ] : v_def.command_list
          cpu        = (v_def.reserved_num_vcpu == null ? var.task_container_reserved_num_vcpu_default == null ? local.l4_map[k].resource_num_vcpu / length(v.container_definition_map) : var.task_container_reserved_num_vcpu_default : v_def.reserved_num_vcpu) * 1024
          entryPoint = v_def.entry_point == null ? var.task_container_entry_point_default : v_def.entry_point
          environment = [
            for k, v in merge(
              {
                AWS_DEFAULT_REGION = var.std_map.aws_region_name
              },
              v_def.environment_map == null ? var.task_container_environment_map_default : v_def.environment_map
              ) : {
              name  = k
              value = v
            }
          ]
          environmentFiles = [
            for file in v_def.environment_file_list == null ? var.task_container_environment_file_list_default : v_def.environment_file_list : file
          ]
          essential = true
          image     = v_def.image != null ? v_def.image : var.task_container_image_default
          linuxParameters = {
            initProcessEnabled = true
          }
          logConfiguration = {
            logDriver = "awslogs"
            options = {
              awslogs-group         = module.task_log.data[k].log_group_name
              awslogs-region        = var.std_map.aws_region_name
              awslogs-stream-prefix = local.l1_map[k].name_context
            }
          }
          memoryReservation = (v_def.reserved_memory_gib == null ? var.task_container_reserved_memory_gib_default == null ? local.l7_map[k].resource_memory_gib / length(v.container_definition_map) : var.task_container_reserved_memory_gib_default : v_def.reserved_memory_gib) * 1024
          mountPoints = [
            for name, mount_data in v_def.mount_point_map == null ? var.task_container_mount_point_map_default : v_def.mount_point_map : {
              containerPath = mount_data.container_path
              readOnly      = mount_data.read_only != null ? mount_data.read_only : var.task_container_mount_read_only_default
              sourceVolume  = name
            }
          ]
          name = k_def
          portMappings = [
            for k_port, v_port in v_def.port_map == null ? var.task_container_port_map_default : v_def.port_map : {
              containerPort = tonumber(k_port)
              hostPort      = tonumber(v_port.host_port == null ? k_port : v_port.host_port)
              protocol      = v_port.protocol == null ? var.task_container_port_protocol_default : v_port.protocol
            }
          ]
          privileged             = v_def.privileged == null ? var.task_container_privileged_default : v_def.privileged
          readonlyRootFilesystem = v_def.read_only_root_file_system == null ? var.task_container_read_only_root_file_system_default : v_def.read_only_root_file_system
          secrets = [
            for k_secret, v_secret in v_def.secret_map == null ? var.task_container_secret_map_default : v_def.secret_map :
            {
              name      = k_secret
              valueFrom = v_secret
            }
          ]
          systemControls = []
          user           = v_def.username == null ? var.task_container_username_default : v_def.username
          volumesFrom    = []
        }
      ]
    }
  }
  lx_map = {
    for k, v in local.l0_map : k =>
    merge(local.l1_map[k], local.l2_map[k], local.l3_map[k], local.l4_map[k], local.l5_map[k], local.l6_map[k], local.l7_map[k], local.l8_map[k])
  }
  o1_map = {
    for k, v in local.lx_map : k => {
      task_def_arn_split             = split(":", aws_ecs_task_definition.this_task[k].arn) # Get rid of version number at end
      task_definition_arn_latest_rev = aws_ecs_task_definition.this_task[k].arn
    }
  }
  o2_map = {
    for k, v in local.lx_map : k => {
      task_definition_arn_latest = join(":", slice(local.o1_map[k].task_def_arn_split, 0, length(local.o1_map[k].task_def_arn_split) - 1))
    }
  }
  output_data = {
    for k, v in local.lx_map : k => merge(
      {
        for k_attr, v_attr in v : k_attr => v_attr if !contains(["alert_event_pattern_json"], k_attr)
      },
      {
        for k_o, v_o in local.o1_map[k] : k_o => v_o if !contains(["task_def_arn_split"], k_o)
      },
      local.o2_map[k],
      {
        alert = module.alert_trigger.data[k]
        event = v.schedule_expression == null ? null : module.this_event_bus.data[k]
        log   = module.task_log.data[k]
        role  = module.task_role[k].data
      },
    )
  }
}
