variable "vpc_az_key_list_default" {
  type    = list(string)
  default = []
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
  type = string
}

variable "vpc_security_group_key_list_default" {
  type    = list(string)
  default = []
}

variable "vpc_segment_key_default" {
  type    = string
  default = null
}

variable "vpc_map" {
  type = map(object({
    vpc_az_key_list             = optional(list(string))
    vpc_key                     = optional(string)
    vpc_security_group_key_list = optional(list(string))
    vpc_segment_key             = optional(string)
  }))
}
