variable "monitor_data" {
  type = object({
    cw_config_data = object({
      ecs = object({
        ssm_param_name = object({
          cpu = string
          gpu = string
        })
      })
    })
  })
}

variable "nat_map" {
  type = map(object({
    image_id                    = optional(string)
    instance_storage_gib        = optional(number)
    instance_type               = optional(string)
    k_az                        = string
    k_az_full                   = string
    key_name                    = optional(string)
    k_seg                       = string
    k_vpc                       = string
    tags                        = map(string)
    vpc_security_group_key_list = optional(list(string))
    vpc_segment_key             = optional(string)
  }))
}

variable "nat_image_id_default" {
  type    = string
  default = null
}

variable "nat_instance_storage_gib_default" {
  type    = number
  default = 16
}

variable "nat_instance_type_default" {
  type    = string
  default = "t4g.nano"
}

variable "nat_key_name_default" {
  type        = string
  default     = null
  description = "If provided, also add ssh rule to vpc_security_group_key_list"
}

variable "std_map" {
  type = object({
    config_name          = string
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}

variable "vpc_data_map" {
  type = map(object({
    security_group_id_map = map(string)
    segment_map = map(object({
      route_public  = bool
      subnet_id_map = map(string)
    }))
  }))
}

variable "vpc_security_group_key_list_default" {
  type    = list(string)
  default = ["internal_all_in", "world_all_out", "world_icmp_in"]
}

variable "vpc_segment_key_default" {
  type    = string
  default = "public"
}
