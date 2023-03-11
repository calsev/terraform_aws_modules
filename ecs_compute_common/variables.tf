variable "compute_map" {
  type = map(object({
    image_id                    = optional(string)
    instance_allocation_type    = optional(string)
    instance_storage_gib        = optional(number)
    instance_type               = optional(string)
    key_name                    = optional(string)
    vpc_security_group_key_list = optional(list(string))
    vpc_segment_key             = optional(string)
    vpc_subnet_key_list         = optional(list(string))
    user_data_commands          = optional(list(string))
  }))
}

variable "compute_image_id_default" {
  type = string
}

variable "compute_instance_allocation_type_default" {
  type = string
}

variable "compute_instance_storage_gib_default" {
  type = number
}

variable "compute_instance_type_default" {
  type = string
}

variable "compute_key_name_default" {
  type = string
}

variable "compute_vpc_security_group_key_list_default" {
  type    = list(string)
  default = ["world_all_out"]
}

variable "compute_vpc_segment_key_default" {
  type    = string
  default = "internal"
}

variable "compute_vpc_subnet_key_list_default" {
  type    = list(string)
  default = ["a", "b"]
}

variable "compute_user_data_commands_default" {
  type = list(string)
}

variable "cw_config_data" {
  type = object({
    ecs = object({
      ssm_param_name = object({
        cpu = string
        gpu = string
      })
    })
  })
}

variable "iam_instance_profile_arn_ecs" {
  type = string
}

variable "set_ecs_cluster_in_user_data" {
  type = bool
}

variable "std_map" {
  type = object({
    config_name          = string
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}

variable "vpc_data" {
  type = object({
    security_group_map = map(object({
      id = string
    }))
    segment_map = map(object({
      subnet_map = map(object({
        subnet_id = string
      }))
    }))
  })
}
