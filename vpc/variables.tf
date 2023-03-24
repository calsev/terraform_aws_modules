variable "std_map" {
  type = object({
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}

variable "vpc_map" {
  type = map(object({
    # Subnets can be added after creation, but not segments
    availability_zone_count = optional(number)
    nat_gateway_enabled     = optional(bool)
    nat_gateway_multi_az    = optional(bool)
    segment_map = map(object({
      route_internal = optional(bool)
      route_public   = optional(bool)
    }))
    subnet_bit_length    = optional(number) # The number of bits to add to the mask, defaults to ceil(log(#segments * #azs, 2)), set higher to accommodate future AZs
    vpc_assign_ipv6_cidr = optional(bool)
    vpc_cidr             = string
  }))
}

variable "vpc_availability_zone_count_default" {
  type    = number
  default = 2
}

variable "vpc_assign_ipv6_cidr_default" {
  type    = bool
  default = true
}

variable "vpc_nat_gateway_enabled_default" {
  type    = bool
  default = true
}

variable "vpc_nat_gateway_multi_az_default" {
  type        = bool
  default     = true
  description = "If false, a single NAT will be created"
}

variable "vpc_segment_route_internal_default" {
  type    = bool
  default = true
}

variable "vpc_segment_route_public_default" {
  type    = bool
  default = false
}
