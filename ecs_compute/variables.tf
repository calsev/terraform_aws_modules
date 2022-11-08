variable "compute_environment" {
  type = object({
    image_id                 = string
    instance_allocation_type = optional(string)
    instance_storage_gib     = optional(number)
    instance_type            = string
    key_name                 = optional(string)
    max_instances            = number
    min_instances            = optional(number)
    user_data_commands       = optional(list(string))
  })
}

variable "compute_environment_instance_allocation_type_default" {
  type    = string
  default = "EC2"
}

variable "compute_environment_instance_storage_gib_default" {
  type    = number
  default = 30
}

variable "compute_environment_min_instances_default" {
  type    = number
  default = 0
}

variable "iam_data" {
  type = object({
    iam_instance_profile_arn_for_ecs = string
  })
}

variable "name" {
  type = string
}

variable "security_group_id_list" {
  type = list(string)
}

variable "ssm_param_name_cw_config" {
  type = string
}

variable "std_map" {
  type = object({
    config_name          = string
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}

variable "subnet_id_list" {
  type = list(string)
}
