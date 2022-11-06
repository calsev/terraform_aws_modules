locals {
  bash_entry = ["/usr/bin/bash", "-c"]
  container_command_map = {
    for def in var.container_definition_list : def.name => [
      join(
        " && ",
        concat(
          local.standard_deb_install,
          def.command_list,
        )
      )
    ]
  }
  container_definition_list = [
    for def in var.container_definition_list : {
      command     = local.container_command_map[def.name]
      cpu         = 0
      entryPoint  = local.bash_entry
      environment = local.container_env_map[def.name]
      essential   = true
      image       = def.image != null ? def.image : var.container_image_default
      linuxParameters = {
        initProcessEnabled = true
      }
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = var.log_group_name
          awslogs-region        = var.std_map.aws_region_name
          awslogs-stream-prefix = local.resource_name
        }
      }
      memoryReservation = def.memory_reservation_mib != null ? def.memory_reservation_mib : var.container_memory_reservation_mib_default
      mountPoints = def.mount_point_map == null ? [] : [
        for name, mount_data in def.mount_point_map : {
          containerPath = mount_data.container_path
          readOnly      = mount_data.read_only != null ? mount_data.read_only : var.container_mount_read_only_default
          sourceVolume  = name
        }
      ]
      name         = def.name
      portMappings = local.container_port_map[def.name]
      volumesFrom  = []
    }
  ]
  container_env_map = {
    for def in var.container_definition_list : def.name => [
      for k, v in merge(
        local.standard_env_map,
        def.environment_map != null ? def.environment_map : {}
        ) : {
        name  = k
        value = v
      }
    ]
  }
  container_port_map = {
    for def in var.container_definition_list : def.name => [
      for port_map in def.port_map_list != null ? def.port_map_list : [] : {
        containerPort = port_map.container_port
        hostPort      = port_map.host_port != null ? port_map.host_port : port_map.container_port
        protocol      = port_map.protocol != null ? port_map.protocol : var.container_port_protocol_default
      }
    ]
  }
  output_data = {
    iam_role_arn_ecs_task          = var.iam_role_arn_ecs_task
    task_definition_arn_latest     = local.task_definition_arn_latest
    task_definition_arn_latest_rev = aws_ecs_task_definition.this_task.arn
  }
  deb_package   = "apt-get install -qqy --no-install-recommends"
  resource_name = "${var.std_map.resource_name_prefix}${var.name}${var.std_map.resource_name_suffix}"
  standard_deb_install = [
    "ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone",
    "apt-get -qq update",
    "apt-get -qq upgrade",
    "${local.deb_package} tzdata",
    "${local.deb_package} curl",
    "${local.deb_package} ca-certificates",
    "cd tmp",
    "curl 'https://awscli.amazonaws.com/awscli-exe-linux-${var.arch}.zip' -o 'awscliv2.zip'",
    "${local.deb_package} unzip",
    "unzip -q awscliv2.zip",
    "aws/install",
    "cd /",
  ]
  standard_env_map = {
    AWS_DEFAULT_REGION = var.std_map.aws_region_name
    DEBIAN_FRONTEND    = "noninteractive"
    TERM               = "xterm-256color"
    TZ                 = "Etc/UTC"
  }
  tags = merge(
    var.std_map.tags,
    {
      Name = local.resource_name
    }
  )
  task_def_arn_split         = split(":", aws_ecs_task_definition.this_task.arn) # Get rid of version number at end
  task_definition_arn_latest = join(":", slice(local.task_def_arn_split, 0, length(local.task_def_arn_split) - 1))
  task_efs_map = {
    for name, volume_data in var.efs_volume_map : name => {
      efs_volume_configuration = {
        authorization_config = volume_data.root_directory != null ? null : volume_data.authorization_config != null ? {
          access_point_id = volume_data.authorization_config.access_point_id
          iam             = volume_data.authorization_config.iam != null ? volume_data.authorization_config.iam : var.efs_authorization_iam_default
          } : {
          access_point_id = null
          iam             = var.efs_authorization_iam_default
        }
        file_system_id     = volume_data.file_system_id
        root_directory     = volume_data.root_directory != null ? volume_data.root_directory : var.efs_root_directory_default
        transit_encryption = volume_data.transit_encryption != null ? volume_data.transit_encryption : var.efs_transit_encryption_default
      }
    }
  }
}
