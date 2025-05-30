{{ name.var() }}

{{ std.map() }}

variable "vpc_map" {
  type = map(object({
    vpc_assign_ipv6_cidr = optional(bool)
    vpc_cidr_block       = string
  }))
}

variable "vpc_assign_ipv6_cidr_default" {
  type    = bool
  default = true
}
