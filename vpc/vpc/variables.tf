variable "std_map" {
  type = object({
    name_replace_regex   = string
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}

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
