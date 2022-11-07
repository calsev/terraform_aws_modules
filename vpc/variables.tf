variable "std_map" {
  type = object({
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}

variable "vpc_data" {
  type = object({
    segment_map = map(object({
      subnet_cidr_list = list(string)
      route_internal   = bool
      route_public     = bool
    }))
    vpc_map = object({
      assign_ipv6_cidr = optional(bool)
      cidr             = string
    })
  })
}

variable "vpc_assign_ipv6_cidr_default" {
  type    = bool
  default = true
}

variable "vpc_name" {
  type = string
}
