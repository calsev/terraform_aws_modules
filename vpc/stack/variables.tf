variable "iam_data" {
  type = object({
    key_pair_map = map(object({
      key_pair_name = string
    }))
  })
  default     = null
  description = "Must be provided if using a nat instance"
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
  default     = null
  description = "Must be provided if using a nat instance"
}

variable "std_map" {
  type = object({
    aws_account_id       = string
    aws_region_name      = string
    config_name          = string
    name_replace_regex   = string
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}

variable "vpc_map" {
  type = map(object({
    nat_gateway_enabled = optional(bool)
    nat_multi_az        = optional(bool)
    peer_map = optional(map(object({ # Key can be a VPC key or VPC ID
    })))
    segment_map = optional(map(object({
      route_internal = optional(bool)
      route_public   = optional(bool)
    })))
    subnet_bit_length = optional(number) # The number of bits to add to the mask, defaults to ceil(log(#segments * #azs, 2)), set higher to accommodate future AZs
    vpc_cidr_block    = string
  }))
}

variable "vpc_nat_multi_az_default" {
  type        = bool
  default     = true
  description = "If false, a single NAT will be created"
}
