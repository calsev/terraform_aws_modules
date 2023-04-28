variable "ecs_cluster_data" {
  type = map(object({
    instance_type_memory_gib = number
    instance_type_num_vcpu   = number
    ecs_cluster_arn          = string
  }))
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

variable "std_map" {
  type = object({
    access_title_map               = map(string)
    aws_account_id                 = string
    aws_region_name                = string
    iam_partition                  = string
    resource_name_prefix           = string
    resource_name_suffix           = string
    service_resource_access_action = map(map(map(list(string))))
    tags                           = map(string)
  })
}

variable "task_map" {
  type = map(object({
    alert_level = optional(string)
    container_definition_list = list(object({
      command_join    = optional(bool)
      command_list    = list(string)
      environment_map = optional(map(string))
      entry_point     = optional(list(string))
      image           = optional(string)
      name            = string
      mount_point_map = optional(map(object({
        container_path = string
        read_only      = optional(bool)
      })))
      port_map_list = optional(list(object({
        container_port = number
        host_port      = optional(number)
        protocol       = optional(string)
      })))
      reserved_memory_gib = optional(number)
      reserved_num_vcpu   = optional(number)
    }))
    ecs_cluster_key = optional(string)
    efs_volume_map = optional(map(object({
      authorization_config = optional(object({
        access_point_id = optional(string)
        iam             = optional(string)
      }))
      file_system_id          = string
      root_directory          = optional(string)
      transit_encryption      = optional(string)
      transit_encryption_port = optional(string)
    })))
    iam_role_arn             = optional(string)
    log_group_name           = optional(string)
    resource_memory_gib      = optional(string)
    resource_memory_host_gib = optional(number)
    resource_num_vcpu        = optional(string)
    schedule_expression      = optional(string)
  }))
}

variable "task_alert_level_default" {
  type        = string
  default     = "general_medium"
  description = "Set to null to disable alerting"
}

variable "task_container_command_join_default" {
  type    = bool
  default = true
}

variable "task_container_entry_point_default" {
  type    = list(string)
  default = ["/usr/bin/bash", "-cex"]
}

variable "task_container_image_default" {
  type    = string
  default = "public.ecr.aws/lts/ubuntu:latest"
}

variable "task_container_mount_read_only_default" {
  type    = bool
  default = false
}

variable "task_container_port_protocol_default" {
  type    = string
  default = "tcp"
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

variable "task_ecs_cluster_key_default" {
  type        = string
  default     = null
  description = "Defaults to the key for the task"
}

variable "task_efs_volume_map_default" {
  type = map(object({
    authorization_config = optional(object({
      access_point_id = optional(string)
      iam             = optional(string)
    }))
    file_system_id          = string
    root_directory          = optional(string)
    transit_encryption      = optional(string)
    transit_encryption_port = optional(number)
  }))
  default = {}
}

variable "task_efs_authorization_iam_default" {
  type    = string
  default = "ENABLED"
}

variable "task_efs_root_directory_default" {
  type    = string
  default = "/"
}

variable "task_efs_transit_encryption_default" {
  type    = string
  default = "ENABLED"
}

variable "task_efs_transit_encryption_port_default" {
  type    = number
  default = null
}

variable "task_iam_role_arn_default" {
  type        = string
  default     = null
  description = "The role the task will assume"
}

variable "task_log_group_name_default" {
  type    = string
  default = null
}

variable "task_resource_memory_gib_default" {
  type        = number
  default     = null
  description = "Defaults to instance_type_memory_gib - task_memory_host_gib_default"
}

variable "task_resource_memory_host_gib_default" {
  type        = number
  default     = 0.5
  description = "The default memory left for host OS usage."
}

variable "task_resource_num_vcpu_default" {
  type        = number
  default     = null
  description = "Defaults to number of CPUs for the instance x 1024"
}

variable "task_schedule_expression_default" {
  type    = string
  default = null
}
