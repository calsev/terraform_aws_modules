variable "cw_config_data" {
  type = object({
    ecs = object({
      ssm_param_name = object({
        cpu = string
        gpu = string
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

variable "vpc_subnet_map_data" {
  type = object({
    availability_zone_letter_list = list(string)
  })
}

variable "vpc_map" {
  type = map(object({
    nat_gateway_enabled  = optional(bool)
    nat_instance_enabled = optional(bool)
    nat_multi_az         = optional(bool)
  }))
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
