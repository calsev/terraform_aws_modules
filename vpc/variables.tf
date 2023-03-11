variable "std_map" {
  type = object({
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}

variable "vpc_map" {
  type = map(object({
    segment_map = map(object({
      subnet_cidr_list = list(string)
      route_internal   = optional(bool)
      route_public     = optional(bool)
    }))
    vpc_assign_ipv6_cidr = optional(bool)
    vpc_cidr             = string
  }))
}

variable "vpc_assign_ipv6_cidr_default" {
  type    = bool
  default = true
}

variable "vpc_segment_route_internal_default" {
  type    = bool
  default = true
}

variable "vpc_segment_route_public_default" {
  type    = bool
  default = false
}
