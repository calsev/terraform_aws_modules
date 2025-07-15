variable "compute_map" {
  type = map(object({
    auto_scaling_iam_role_arn_service_linked    = optional(string)
    auto_scaling_num_instances_max              = optional(number)
    auto_scaling_num_instances_min              = optional(number)
    auto_scaling_protect_from_scale_in          = optional(bool)
    elb_target_group_key_list                   = optional(list(string))
    health_check_type                           = optional(string)
    iam_instance_profile_arn                    = optional(string)
    image_id                                    = optional(string)
    instance_allocation_type                    = optional(string)
    instance_lifetime_max_hours                 = optional(number)
    instance_refresh_protected_instance_enabled = optional(bool)
    instance_storage_gib                        = optional(number)
    instance_type                               = optional(string)
    key_pair_key                                = optional(string)
    log_retention_days                          = optional(number)
    provider_instance_warmup_period_s           = optional(number)
    provider_managed_scaling_enabled            = optional(bool)
    provider_managed_termination_protection     = optional(bool)
    provider_step_size_max                      = optional(number)
    provider_step_size_min                      = optional(number)
    provider_target_capacity                    = optional(number)
    vpc_az_key_list                             = optional(list(string))
    vpc_key                                     = optional(string)
    vpc_security_group_key_list                 = optional(list(string))
    vpc_segment_key                             = optional(string)
    user_data_command_list                      = optional(list(string))
  }))
}

variable "compute_auto_scaling_iam_role_arn_service_linked_default" {
  type    = string
  default = null
}

variable "compute_auto_scaling_num_instances_max_default" {
  type    = number
  default = 1
}

variable "compute_auto_scaling_num_instances_min_default" {
  type    = number
  default = 0
}

variable "compute_auto_scaling_protect_from_scale_in_default" {
  type        = bool
  default     = null
  description = "Prevents instance cycling but required for ECS delegation. Sticks to instances once created. Defaults to provider_managed_termination_protection."
}

variable "compute_elb_target_group_key_list_default" {
  type    = list(string)
  default = []
}

variable "compute_health_check_type_default" {
  type        = string
  default     = null
  description = "Defaults to EC2 if no target is attached, otherwise ELB. Must be set to ELB manually for any service attached to an ELB."
  validation {
    condition     = var.compute_health_check_type_default == null ? true : contains(["EC2", "ELB"], var.compute_health_check_type_default)
    error_message = "Invalid health check type"
  }
}

variable "compute_iam_instance_profile_arn_default" {
  type        = string
  default     = null
  description = "Defaults to role from iam_data"
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

variable "compute_instance_lifetime_max_hours_default" {
  type        = number
  default     = 0
  description = "Set nonzero to enable automatic cycling"
}

variable "compute_instance_refresh_protected_instance_enabled_default" {
  type        = bool
  default     = true
  description = "Allows autonomous auto scale-in actions such as instance rotation."
}

variable "compute_instance_storage_gib_default" {
  type        = number
  default     = 30
  description = "This is the minimum allowed"
}

variable "compute_instance_type_default" {
  type    = string
  default = "t4g.nano"
}

variable "compute_key_pair_key_default" {
  type    = string
  default = null
}

variable "compute_log_retention_days_default" {
  type    = number
  default = 7
}

variable "compute_provider_instance_warmup_period_s_default" {
  type        = number
  default     = 300
  description = "Ignored for Fargate capacity type"
}

variable "compute_provider_managed_scaling_enabled_default" {
  type        = bool
  default     = true
  description = "Ignored for Fargate capacity type"
}

variable "compute_provider_managed_termination_protection_default" {
  type        = bool
  default     = null
  description = "Delegates termination to ECS, preventing scale in for rotation. Defaults to true if instance_lifetime_max_hours is zero. Ignored for Fargate capacity type."
}

variable "compute_provider_step_size_max_default" {
  type        = number
  default     = 1
  description = "Ignored for Fargate capacity type"
}

variable "compute_provider_step_size_min_default" {
  type        = number
  default     = 1
  description = "Ignored for Fargate capacity type"
}

variable "compute_provider_target_capacity_default" {
  type        = number
  default     = 100
  description = "Ignored for Fargate capacity type"
}

variable "compute_user_data_command_list_default" {
  type    = list(string)
  default = null
}

variable "elb_target_data_map" {
  type = map(object({
    target_group_arn = string
  }))
  default     = null
  description = "Must be provided if any ASG has an attached ELB"
}

variable "iam_data" {
  type = object({
    iam_instance_profile_arn_ecs = string
    key_pair_map = map(object({
      key_pair_name = string
    }))
  })
}

variable "monitor_data" {
  type = object({
    alert = object({
      topic_map = map(object({
        topic_arn = string
      }))
    })
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

variable "name_append_default" {
  type        = string
  default     = ""
  description = "Appended after key"
}

variable "name_include_app_fields_default" {
  type        = bool
  default     = true
  description = "If true, standard project context will be prefixed to the name. Ignored if not name_infix."
}

variable "name_infix_default" {
  type        = bool
  default     = true
  description = "If true, standard project prefix and resource suffix will be added to the name"
}

variable "name_prefix_default" {
  type        = string
  default     = ""
  description = "Prepended before context prefix"
}

variable "name_prepend_default" {
  type        = string
  default     = ""
  description = "Prepended before key"
}

# tflint-ignore: terraform_unused_declarations
variable "name_regex_allow_list" {
  type        = list(string)
  default     = []
  description = "By default, all punctuation is replaced by -"
}

variable "name_suffix_default" {
  type        = string
  default     = ""
  description = "Appended after context suffix"
}

variable "std_map" {
  type = object({
    access_title_map               = map(string)
    aws_account_id                 = string
    aws_region_name                = string
    config_name                    = string
    env                            = string
    iam_partition                  = string
    name_replace_regex             = string
    resource_name_prefix           = string
    resource_name_suffix           = string
    service_resource_access_action = map(map(map(list(string))))
    tags                           = map(string)
  })
}

variable "vpc_az_key_list_default" {
  type = list(string)
  default = [
    "a",
    "b",
  ]
}

variable "vpc_data_map" {
  type = map(object({
    name_simple           = string
    security_group_id_map = map(string)
    segment_map = map(object({
      route_public  = bool
      subnet_id_map = map(string)
      subnet_map = map(object({
        availability_zone_name = string
      }))
    }))
    vpc_assign_ipv6_cidr = bool
    vpc_cidr_block       = string
    vpc_id               = string
    vpc_ipv6_cidr_block  = string
  }))
}

variable "vpc_key_default" {
  type    = string
  default = null
}

variable "vpc_security_group_key_list_default" {
  type = list(string)
  default = [
    "world_all_out",
  ]
}

variable "vpc_segment_key_default" {
  type    = string
  default = "internal"
}
