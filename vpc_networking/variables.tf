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
  default     = null
  description = "Must be provided if using a nat instance"
}

variable "std_map" {
  type = object({
    config_name          = string
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}

variable "vpc_map" {
  type = map(object({
    # Subnets can be added after creation, but not segments
    availability_zone_count = optional(number)
    name_context            = string
    name_simple             = string
    nat_gateway_enabled     = optional(bool)
    nat_instance_enabled    = optional(bool)
    nat_multi_az            = optional(bool)
    security_group_id_map   = map(string)
    segment_map = optional(map(object({
      route_internal = optional(bool)
      route_public   = optional(bool)
    })))
    subnet_bit_length    = optional(number) # The number of bits to add to the mask, defaults to ceil(log(#segments * #azs, 2)), set higher to accommodate future AZs
    tags                 = map(string)
    vpc_assign_ipv6_cidr = bool
    vpc_cidr_block       = string
    vpc_id               = string
    vpc_ipv6_cidr_block  = string
  }))
}

variable "vpc_availability_zone_count_default" {
  type    = number
  default = 2
}

variable "vpc_nat_gateway_enabled_default" {
  type        = bool
  default     = true
  description = "Ignored if NAT instance is enabled"
}

variable "vpc_nat_instance_enabled_default" {
  type        = bool
  default     = false
  description = "Currently not supported"
}

variable "vpc_nat_multi_az_default" {
  type        = bool
  default     = true
  description = "If false, a single NAT will be created"
}

variable "vpc_segment_map_default" {
  type = map(object({
    route_internal = optional(bool)
    route_public   = optional(bool)
  }))
  default = {
    public = {
      route_internal = true
      route_public   = true
    }
    internal = {
      route_internal = true
      route_public   = false
    }
  }
}

variable "vpc_segment_route_internal_default" {
  type    = bool
  default = true
}

variable "vpc_segment_route_public_default" {
  type    = bool
  default = false
}
