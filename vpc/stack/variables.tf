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

variable "s3_data_map" {
  type = map(object({
    bucket_arn = string
  }))
  default     = null
  description = "Must be provided if a log bucket key is specified"
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
    # Subnets can be added after creation, but not segments
    availability_zone_map_key_list = optional(list(string))
    nat_gateway_enabled            = optional(bool)
    nat_multi_az                   = optional(bool)
    peer_map = optional(map(object({ # Key can be a VPC key or VPC ID
    })))
    segment_map = optional(map(object({
      route_internal = optional(bool)
      route_public   = optional(bool)
    })))
    subnet_bit_length                   = optional(number) # The number of bits to add to the mask, defaults to ceil(log(#segments * #azs, 2)), set higher to accommodate future AZs
    vpc_cidr_block                      = string
    vpc_flow_log_destination_bucket_key = optional(string)
  }))
}

variable "vpc_availability_zone_map_key_list_default" {
  type        = list(string)
  default     = ["a", "b"]
  description = "AZs a, ... will be created for each key, mapped to these AWS AZs"
}

variable "vpc_flow_log_destination_bucket_key_default" {
  type        = string
  default     = null
  description = "If true, flow logs will be enabled for the VPC"
}

variable "vpc_nat_multi_az_default" {
  type        = bool
  default     = true
  description = "If false, a single NAT will be created"
}
