variable "arch" {
  type = string
}

variable "container_definition_list" {
  type = list(object({
    command_list           = list(string)
    environment_map        = optional(map(string))
    image                  = optional(string)
    name                   = string
    memory_reservation_mib = optional(number)
    mount_point_map = optional(map(object({
      container_path = string
      read_only      = optional(bool)
    })))
    port_map_list = optional(list(object({
      container_port = number
      host_port      = optional(number)
      protocol       = optional(string)
    })))
  }))
}

variable "container_image_default" {
  type    = string
  default = "ubuntu:latest"
}

variable "container_memory_reservation_mib_default" {
  type    = number
  default = 256
}

variable "container_mount_read_only_default" {
  type    = bool
  default = false
}

variable "container_port_protocol_default" {
  type    = string
  default = "tcp"
}

variable "cron_expression" {
  type    = string
  default = null
}

variable "ecs_cluster_arn" {
  type = string
}

variable "efs_volume_map" {
  type = map(object({
    authorization_config = optional(object({
      access_point_id = optional(string)
      iam             = optional(string)
    }))
    file_system_id     = string
    root_directory     = optional(string)
    transit_encryption = optional(string)
  }))
  default = {}
}

variable "efs_authorization_iam_default" {
  type    = string
  default = "ENABLED"
}

variable "efs_root_directory_default" {
  type    = string
  default = "/"
}

variable "efs_transit_encryption_default" {
  type    = string
  default = "ENABLED"
}

variable "iam_data" {
  type = object({
    iam_role_arn_ecs_start_task     = string
    iam_role_arn_ecs_task_execution = string
  })
}

variable "iam_role_arn_ecs_task" {
  type        = string
  description = "The role the task will assume"
}

variable "log_group_name" {
  type = string
}

variable "name" {
  type = string
}

variable "std_map" {
  type = object({
    access_title_map = map(string)
    assume_role_json = object({
      ecs_task = string
    })
    aws_account_id                 = string
    aws_region_name                = string
    iam_partition                  = string
    resource_name_prefix           = string
    resource_name_suffix           = string
    service_resource_access_action = map(map(map(list(string))))
    tags                           = map(string)
  })
}
