variable "compute_map" {
  type = map(object({
    image_id                    = optional(string)
    instance_allocation_type    = optional(string)
    instance_storage_gib        = optional(number)
    instance_type               = optional(string)
    key_pair_key                = optional(string)
    max_instances               = optional(number)
    min_instances               = optional(number)
    vpc_az_key_list             = optional(list(string))
    vpc_key                     = optional(string)
    vpc_security_group_key_list = optional(list(string))
    vpc_segment_key             = optional(string)
    user_data_command_list      = optional(list(string))
  }))
}

variable "compute_image_id_default" {
  type    = string
  default = null
}

variable "compute_instance_allocation_type_default" {
  type    = string
  default = "EC2"
}

variable "compute_instance_storage_gib_default" {
  type    = number
  default = 30
}

variable "compute_instance_type_default" {
  type    = string
  default = null
}

variable "compute_key_pair_key_default" {
  type    = string
  default = null
}

variable "compute_max_instances_default" {
  type    = number
  default = 1
}

variable "compute_min_instances_default" {
  type    = number
  default = 0
}

variable "compute_user_data_command_list_default" {
  type    = list(string)
  default = null
}

variable "iam_data" {
  type = object({
    iam_instance_profile_arn_ecs  = string
    iam_role_arn_batch_service    = string
    iam_role_arn_batch_spot_fleet = string
    key_pair_map = map(object({
      key_pair_name = string
    }))
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

{{ std.map() }}

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
