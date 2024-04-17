variable "elb_target_data_map" {
  type = map(object({
    target_group_arn = string
  }))
  default     = null
  description = "Must be provided if any ASG has an attached ELB"
}

variable "group_map" {
  type = map(object({
    auto_scaling_iam_role_arn_service_linked    = optional(string)
    auto_scaling_num_instances_max              = optional(number)
    auto_scaling_num_instances_min              = optional(number)
    auto_scaling_protect_from_scale_in          = optional(bool)
    elb_target_group_key_list                   = optional(list(string))
    health_check_type                           = optional(string)
    instance_maintenance_max_healthy_percentage = optional(number)
    instance_maintenance_min_healthy_percentage = optional(number)
    launch_template_id                          = optional(string)
    name_include_app_fields                     = optional(bool)
    name_infix                                  = optional(bool)
    placement_group_id                          = optional(string)
    vpc_az_key_list                             = optional(list(string))
    vpc_key                                     = optional(string)
    vpc_security_group_key_list                 = optional(list(string))
    vpc_segment_key                             = optional(string)
  }))
}

variable "group_auto_scaling_iam_role_arn_service_linked_default" {
  type    = string
  default = null
}

variable "group_auto_scaling_num_instances_max_default" {
  type    = number
  default = 1
}

variable "group_auto_scaling_num_instances_min_default" {
  type    = number
  default = 0
}

variable "group_auto_scaling_protect_from_scale_in_default" {
  type        = bool
  default     = true
  description = "This is required for managed termination protection in ECS"
}

variable "group_elb_target_group_key_list_default" {
  type        = list(string)
  default     = []
  description = "This value is typically used with instance auto scaling. For ECS the target group is attached to the service."
}

variable "group_health_check_type_default" {
  type        = string
  default     = null
  description = "Defaults to EC2 if no target is attached, otherwise ELB. Must be set to ELB manually for any service attached to an ELB."
  validation {
    condition     = var.group_health_check_type_default == null ? true : contains(["EC2", "ELB"], var.group_health_check_type_default)
    error_message = "Invalid health check type"
  }
}

variable "group_instance_maintenance_max_healthy_percentage_default" {
  type    = number
  default = 200
}

variable "group_instance_maintenance_min_healthy_percentage_default" {
  type    = number
  default = 100
}

variable "group_launch_template_id_default" {
  type    = string
  default = null
}

variable "group_name_include_app_fields_default" {
  type        = bool
  default     = false
  description = "If true, the Terraform project context will be included in the name"
}

variable "group_name_infix_default" {
  type    = bool
  default = true
}

variable "group_placement_group_id_default" {
  type    = string
  default = null
}

variable "std_map" {
  type = object({
    name_replace_regex   = string
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
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
