variable "alert_enabled_default" {
  type    = bool
  default = true
}

variable "alert_level_default" {
  type    = string
  default = "general_medium"
}

variable "ecs_cluster_data" {
  type = map(object({
    capability_type = string
    instance_template = optional(object({
      instance_type_memory_gib = number
      instance_type_num_vcpu   = number
    }))
    ecs_cluster_arn = string
  }))
  description = "Instance values must be provided for EC2 capacity type"
}

variable "iam_data" {
  type = object({
    iam_policy_arn_batch_submit_job = string
    iam_policy_arn_ecs_start_task   = string
    iam_role_arn_ecs_task_execution = string
  })
}

variable "monitor_data" {
  type = object({
    alert = object({
      topic_map = map(object({
        topic_arn = string
      }))
    })
  })
}

variable "role_policy_attach_arn_map_default" {
  type    = map(string)
  default = {}
}

variable "role_policy_create_json_map_default" {
  type    = map(string)
  default = {}
}

variable "role_policy_inline_json_map_default" {
  type    = map(string)
  default = {}
}

variable "role_policy_managed_name_map_default" {
  type    = map(string)
  default = {}
}

variable "std_map" {
  type = object({
    access_title_map               = map(string)
    aws_account_id                 = string
    aws_region_name                = string
    iam_partition                  = string
    name_replace_regex             = string
    resource_name_prefix           = string
    resource_name_suffix           = string
    service_resource_access_action = map(map(map(list(string))))
    tags                           = map(string)
  })
}

variable "task_map" {
  type = map(object({
    alert_enabled = optional(bool)
    alert_level   = optional(string)
    container_definition_map = map(object({
      command_join          = optional(bool)
      command_list          = optional(list(string))
      environment_file_list = optional(list(string))
      environment_map       = optional(map(string))
      entry_point           = optional(list(string))
      image                 = optional(string)
      mount_point_map = optional(map(object({
        container_path = string
        read_only      = optional(bool)
      })))
      port_map = optional(map(object({
        host_port = optional(number) # Defaults to container port (key)
        protocol  = optional(string)
      })))
      privileged                 = optional(bool)
      read_only_root_file_system = optional(bool)
      reserved_memory_gib        = optional(number)
      reserved_num_vcpu          = optional(number)
      secret_map                 = optional(map(string))
      username                   = optional(string)
    }))
    docker_volume_map = optional(map(object({
      auto_provision_enabled = optional(bool)
      driver                 = optional(string)
      driver_option_map      = optional(map(string))
      label_map              = optional(map(string))
      scope                  = optional(string)
    })))
    ecs_cluster_key = optional(string)
    efs_volume_map = optional(map(object({
      authorization_access_point_id = optional(string)
      authorization_iam_enabled     = optional(bool)
      file_system_id                = string
      root_directory                = optional(string)
      transit_encryption_enabled    = optional(bool)
      transit_encryption_port       = optional(string)
    })))
    iam_role_arn_execution       = optional(string)
    network_mode                 = optional(string)
    resource_memory_gib          = optional(number)
    resource_memory_host_gib     = optional(number)
    resource_num_vcpu            = optional(string)
    role_policy_attach_arn_map   = optional(map(string))
    role_policy_create_json_map  = optional(map(string))
    role_policy_inline_json_map  = optional(map(string))
    role_policy_managed_name_map = optional(map(string))
    schedule_expression          = optional(string)
  }))
}

variable "task_container_command_join_default" {
  type    = bool
  default = true
}

variable "task_container_entry_point_default" {
  type    = list(string)
  default = ["/usr/bin/bash", "-cex"]
}

variable "task_container_environment_file_list_default" {
  type    = list(string)
  default = []
}

variable "task_container_environment_map_default" {
  type    = map(string)
  default = {}
}

variable "task_container_image_default" {
  type    = string
  default = "public.ecr.aws/lts/ubuntu:latest"
}

variable "task_container_mount_point_map_default" {
  type = map(object({
    container_path = string
    read_only      = optional(bool)
  }))
  default = {}
}

variable "task_container_mount_read_only_default" {
  type    = bool
  default = false
}

variable "task_container_port_map_default" {
  type = map(object({
    host_port = optional(number) # Defaults to container port (key)
    protocol  = optional(string)
  }))
  default = {
    80 = {
      host_port = null
      protocol  = null
    }
  }
}

variable "task_container_port_protocol_default" {
  type    = string
  default = "tcp"
  validation {
    condition     = contains(["tcp", "udp"], var.task_container_port_protocol_default)
    error_message = "Invalid protocol"
  }
}

variable "task_container_privileged_default" {
  type    = bool
  default = false
}

variable "task_container_read_only_root_file_system_default" {
  type        = bool
  default     = true
  description = "A critical severity finding if false"
}

variable "task_container_reserved_memory_gib_default" {
  type        = number
  default     = null
  description = "Defaults to task memory evenly divided between containers"
}

variable "task_container_reserved_num_vcpu_default" {
  type        = number
  default     = null
  description = "Defaults to CPU units for the task divided evenly by tasks"
}

variable "task_container_secret_map_default" {
  type    = map(string)
  default = {}
}

variable "task_container_username_default" {
  type    = string
  default = "ubuntu"
}

variable "task_ecs_cluster_key_default" {
  type        = string
  default     = null
  description = "Defaults to the key for the task"
}

variable "task_efs_volume_map_default" {
  type = map(object({
    authorization_access_point_id = optional(string)
    authorization_iam_enabled     = optional(bool)
    file_system_id                = string
    root_directory                = optional(string)
    transit_encryption_enabled    = optional(bool)
    transit_encryption_port       = optional(number)
  }))
  default = {}
}

variable "task_efs_authorization_access_point_id_default" {
  type    = string
  default = null
}

variable "task_efs_authorization_iam_enabled_default" {
  type        = bool
  default     = true
  description = "Requires transit encryption"
}

variable "task_efs_root_directory_default" {
  type        = string
  default     = "/"
  description = "Forced to root if an access point is configured"
}

variable "task_efs_transit_encryption_enabled_default" {
  type        = bool
  default     = true
  description = "Must be true if IAM is enabled"
}

variable "task_efs_transit_encryption_port_default" {
  type    = number
  default = null
}

variable "task_docker_volume_map_default" {
  type = map(object({
    auto_provision_enabled = optional(bool)
    driver                 = optional(string)
    driver_option_map      = optional(map(string))
    label_map              = optional(map(string))
    scope                  = optional(string)
  }))
  default = {}
}

variable "task_docker_volume_auto_provision_enabled_default" {
  type        = bool
  default     = true
  description = "Ignored unless scope is shared"
}

variable "task_docker_volume_driver_default" {
  type    = string
  default = "local"
}

variable "task_docker_volume_driver_option_map_default" {
  type    = map(string)
  default = {}
}

variable "task_docker_volume_label_map_default" {
  type    = map(string)
  default = {}
}

variable "task_docker_volume_scope_default" {
  type    = string
  default = "task"
  validation {
    condition     = contains(["shared", "task"], var.task_docker_volume_scope_default)
    error_message = "invalid volume scope"
  }
}

variable "task_iam_role_arn_execution_default" {
  type        = string
  default     = null
  description = "By default, the task execution role is the basic role from IAM data. This overrides the default."
}

variable "task_network_mode_default" {
  type    = string
  default = "awsvpc"
}

variable "task_resource_memory_gib_default" {
  type        = number
  default     = null
  description = "Required for Fargate, for EC2 defaults to instance_type_memory_gib - task_memory_host_gib_default"
  validation {
    condition     = var.task_resource_memory_gib_default == null ? true : var.task_resource_memory_gib_default >= 0.5
    error_message = "Invalid memory requirement: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#task_size"
  }
}

variable "task_resource_memory_host_gib_default" {
  type        = number
  default     = null
  description = "Memory remaining for host OS. Defaults to an empirical fit that is suitable for most applications."
}

variable "task_resource_num_vcpu_default" {
  type        = number
  default     = null
  description = "Required for Fargate, for EC2 defaults to number of CPUs for the instance x 1024"
  validation {
    condition     = var.task_resource_num_vcpu_default == null ? true : var.task_resource_num_vcpu_default >= 0.25
    error_message = "Invalid vCPU requirement: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#task_size"
  }
}

variable "task_schedule_expression_default" {
  type    = string
  default = null
}
