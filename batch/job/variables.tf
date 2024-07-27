variable "alert_enabled_default" {
  type    = bool
  default = true
}

variable "alert_level_default" {
  type    = string
  default = "general_medium"
}

variable "batch_cluster_data" {
  type = map(object({
    instance_type_memory_gib = number
    instance_type_num_gpu    = number
    instance_type_num_vcpu   = number
  }))
}

variable "iam_data" {
  type = object({
    iam_policy_arn_batch_submit_job = string
    iam_policy_arn_ecs_start_task   = string
    iam_role_arn_ecs_task_execution = string
  })
}

variable "job_map" {
  type = map(object({
    alert_enabled     = optional(bool)
    alert_level       = optional(string)
    batch_cluster_key = optional(string)
    command_list      = optional(list(string))
    entry_point       = optional(list(string))
    efs_volume_map = optional(map(object({
      authorization_access_point_id = optional(string)
      authorization_iam_enabled     = optional(bool)
      file_system_id                = optional(string)
      root_directory                = optional(string)
      transit_encryption_enabled    = optional(bool)
      transit_encryption_port       = optional(string)
    })))
    environment_map = optional(map(string))
    host_volume_map = optional(map(object({
      host_path = string
    })))
    iam_role_arn_job_container = optional(string)
    iam_role_arn_job_execution = optional(string)
    image_id                   = optional(string)
    image_tag                  = optional(string)
    mount_map = optional(map(object({
      container_path = string
      volume_key     = optional(string)
    })))
    parameter_map              = optional(map(string))
    privileged                 = optional(bool)
    resource_memory_gib        = optional(number)
    resource_memory_host_gib   = optional(number)
    resource_memory_shared_gib = optional(number)
    resource_num_gpu           = optional(number)
    resource_num_vcpu          = optional(number)
    secret_map                 = optional(map(string))
    ulimit_map = optional(map(object({
      hard_limit = number
      soft_limit = number
    })))
    username = optional(string)
  }))
}

variable "job_batch_cluster_key_default" {
  type        = string
  default     = null
  description = "Defaults to job key"
}

variable "job_command_list_default" {
  type    = list(string)
  default = ["echo Hello World!"]
}

variable "job_efs_volume_map_default" {
  type = map(object({
    authorization_access_point_id = optional(string)
    authorization_iam_enabled     = optional(bool)
    file_system_id                = optional(string)
    root_directory                = optional(string)
    transit_encryption_enabled    = optional(bool)
    transit_encryption_port       = optional(number)
  }))
  default = {}
}

variable "job_efs_authorization_access_point_id_default" {
  type    = string
  default = null
}

variable "job_efs_authorization_iam_enabled_default" {
  type        = bool
  default     = true
  description = "Requires transit encryption"
}

variable "job_efs_file_system_id_default" {
  type    = string
  default = null
}

variable "job_efs_root_directory_default" {
  type        = string
  default     = "/"
  description = "Forced to root if an access point is configured"
}

variable "job_efs_transit_encryption_enabled_default" {
  type        = bool
  default     = true
  description = "Must be true if IAM is enabled"
}

variable "job_efs_transit_encryption_port_default" {
  type    = number
  default = null
}

variable "job_entry_point_default" {
  type        = list(string)
  default     = ["/bin/bash", "-cex"]
  description = "The entry point of the container"
}

variable "job_environment_map_default" {
  type    = map(string)
  default = {}
}

variable "job_host_volume_map_default" {
  type = map(object({
    host_path = string
  }))
  default = {}
}

variable "job_iam_role_arn_job_container_default" {
  type    = string
  default = null
}

variable "job_iam_role_arn_job_execution_default" {
  type        = string
  default     = null
  description = "By default, the job execution role is the basic role from IAM data. This overrides the default."
}

variable "job_image_id_default" {
  type    = string
  default = "public.ecr.aws/ubuntu/ubuntu"
}

variable "job_image_tag_default" {
  type    = string
  default = "22.04"
}

variable "job_mount_map_default" {
  type = map(object({
    container_path = string
    volume_key     = optional(string) # Defaults to mount key
  }))
  default = {}
}

variable "job_parameter_map_default" {
  type    = map(string)
  default = {}
}

variable "job_privileged_default" {
  type    = bool
  default = false
}

variable "job_resource_memory_gib_default" {
  type        = number
  default     = null
  description = "Defaults to instance type memory - host memory - shared memory"
}

variable "job_resource_memory_host_gib_default" {
  type        = number
  default     = null
  description = "Memory remaining for host OS. Defaults to 13/32 + Instance memory / 64"
}

variable "job_resource_memory_shared_gib_default" {
  type    = number
  default = 0.125
}

variable "job_resource_num_gpu_default" {
  type        = number
  default     = null
  description = "Defaults to instance type GPUs"
}

variable "job_resource_num_vcpu_default" {
  type        = number
  default     = null
  description = "Defaults to instance type CPUs"
}

variable "job_secret_map_default" {
  type    = map(string)
  default = {}
}

variable "job_ulimit_map_default" {
  type = map(object({
    hard_limit = number
    soft_limit = number
  }))
  default = {}
}

variable "job_username_default" {
  type    = string
  default = "ubuntu"
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
    name_replace_regex             = string
    resource_name_prefix           = string
    resource_name_suffix           = string
    service_resource_access_action = map(map(map(list(string))))
    tags                           = map(string)
  })
}
