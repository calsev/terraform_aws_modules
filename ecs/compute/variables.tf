variable "compute_map" {
  type = map(object({
    auto_scaling_instance_warmup_period_s       = optional(number)
    auto_scaling_managed_scaling_enabled        = optional(bool)
    auto_scaling_managed_termination_protection = optional(bool)
    auto_scaling_maximum_scaling_step_size      = optional(number)
    auto_scaling_minimum_scaling_step_size      = optional(number)
    auto_scaling_target_capacity                = optional(number)
    image_id                                    = optional(string)
    instance_allocation_type                    = optional(string)
    instance_storage_gib                        = optional(number)
    instance_type                               = optional(string)
    key_name                                    = optional(string)
    log_retention_days                          = optional(number)
    max_instances                               = optional(number)
    min_instances                               = optional(number)
    vpc_az_key_list                             = optional(list(string))
    vpc_key                                     = optional(string)
    vpc_security_group_key_list                 = optional(list(string))
    vpc_segment_key                             = optional(string)
    user_data_commands                          = optional(list(string))
  }))
}

variable "compute_auto_scaling_instance_warmup_period_s_default" {
  type        = number
  default     = 300
  description = "Ignored for Fargate capacity type"
}

variable "compute_auto_scaling_managed_scaling_enabled_default" {
  type        = bool
  default     = true
  description = "Ignored for Fargate capacity type"
}

variable "compute_auto_scaling_managed_termination_protection_default" {
  type        = bool
  default     = true
  description = "Ignored for Fargate capacity type"
}

variable "compute_auto_scaling_maximum_scaling_step_size_default" {
  type        = number
  default     = 1
  description = "Ignored for Fargate capacity type"
}

variable "compute_auto_scaling_minimum_scaling_step_size_default" {
  type        = number
  default     = 1
  description = "Ignored for Fargate capacity type"
}

variable "compute_auto_scaling_target_capacity_default" {
  type        = number
  default     = 100
  description = "Ignored for Fargate capacity type"
}

variable "compute_image_id_default" {
  type    = string
  default = null
}

variable "compute_instance_allocation_type_default" {
  type    = string
  default = "EC2"
  validation {
    condition     = contains(["EC2", "SPOT"], var.compute_instance_allocation_type_default)
    error_message = "Invalid allocation type"
  }
}

variable "compute_instance_storage_gib_default" {
  type    = number
  default = 30
}

variable "compute_instance_type_default" {
  type    = string
  default = "t4g.nano"
}

variable "compute_key_name_default" {
  type    = string
  default = null
}

variable "compute_log_retention_days_default" {
  type    = number
  default = 7
}

variable "compute_max_instances_default" {
  type    = number
  default = 1
}

variable "compute_min_instances_default" {
  type    = number
  default = 0
}

variable "compute_user_data_commands_default" {
  type    = list(string)
  default = null
}

variable "iam_data" {
  type = object({
    iam_instance_profile_arn_ecs = string
  })
}

variable "monitor_data" {
  type = object({
    ecs_ssm_param_map = object({
      cpu = object({
        name_effective = string
      })
      gpu = object({
        name_effective = string
      })
    })
  })
}

variable "std_map" {
  type = object({
    access_title_map               = map(string)
    aws_account_id                 = string
    aws_region_name                = string
    config_name                    = string
    iam_partition                  = string
    name_replace_regex             = string
    resource_name_prefix           = string
    resource_name_suffix           = string
    service_resource_access_action = map(map(map(list(string))))
    tags                           = map(string)
  })
}

variable "vpc_az_key_list_default" {
  type    = list(string)
  default = ["a", "b"]
}

variable "vpc_data_map" {
  type = map(object({
    security_group_id_map = map(string)
    segment_map = map(object({
      route_public  = bool
      subnet_id_map = map(string)
    }))
    vpc_id = string
  }))
}

variable "vpc_key_default" {
  type    = string
  default = null
}

variable "vpc_security_group_key_list_default" {
  type    = list(string)
  default = ["world_all_out"]
}

variable "vpc_segment_key_default" {
  type    = string
  default = "internal"
}