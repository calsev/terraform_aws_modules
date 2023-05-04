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
  })
}

variable "job_map" {
  type = map(object({
    alert_level                = optional(string)
    batch_cluster_key          = optional(string)
    command_list               = optional(list(string))
    environment_map            = optional(map(string))
    iam_role_arn_job_container = optional(string)
    iam_role_arn_job_execution = optional(string)
    image_id                   = optional(string)
    image_tag                  = optional(string)
    mount_map = optional(map(object({
      container_path = string
      source_path    = string
    })))
    parameter_map              = optional(map(string))
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
  }))
}

variable "job_alert_level_default" {
  type        = string
  default     = "general_medium"
  description = "Set to null to disable alerting"
}

variable "job_batch_cluster_key_default" {
  type        = string
  default     = null
  description = "Defaults to job key"
}

variable "job_command_list_default" {
  type    = list(string)
  default = ["echo", "Hello World!"]
}

variable "job_environment_map_default" {
  type    = map(string)
  default = {}
}

variable "job_iam_role_arn_job_container_default" {
  type    = string
  default = null
}

variable "job_iam_role_arn_job_execution_default" {
  type    = string
  default = null
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
    source_path    = string
  }))
  default = {}
}

variable "job_parameter_map_default" {
  type    = map(string)
  default = {}
}

variable "job_resource_memory_gib_default" {
  type        = number
  default     = null
  description = "Defaults to instance type memory - host memory - shared memory"
}

variable "job_resource_memory_host_gib_default" {
  type        = number
  default     = 0.375
  description = "Memory remaining for host OS."
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
