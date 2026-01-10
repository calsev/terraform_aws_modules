variable "ec2_connect_security_group_key_list_default" {
  type = list(string)
  default = [
    "internal_ssh_in"
  ]
}

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
    access_title_map               = map(string)
    aws_account_id                 = string
    aws_region_name                = string
    config_name                    = string
    env                            = string
    iam_partition                  = string
    name_replace_regex             = string
    resource_name_prefix           = string
    resource_name_suffix           = string
    service_resource_access_action = map(map(map(list(string))))
    tags                           = map(string)
  })
}

variable "vpc_map" {
  type = map(object({
    # Subnets can be added after creation, but not segments
    availability_zone_map_key_list      = optional(list(string))
    dns64_enabled                       = optional(bool)
    ec2_connect_security_group_key_list = optional(list(string))
    nacl_egress_map = optional(map(object({
      action          = string
      cidr_block      = string
      from_port       = number
      icmp_code       = number
      icmp_type       = number
      ipv6_cidr_block = string
      protocol        = string
      rule_number     = number
      to_port         = number
    })))
    nacl_ingress_map = optional(map(object({
      action          = string
      cidr_block      = string
      from_port       = number
      icmp_code       = number
      icmp_type       = number
      ipv6_cidr_block = string
      protocol        = string
      rule_number     = number
      to_port         = number
    })))
    name_context                             = string
    name_simple                              = string
    nat_gateway_enabled                      = optional(bool)
    nat_instance_enabled                     = optional(bool)
    nat_multi_az                             = optional(bool)
    public_subnet_assign_public_ip_on_launch = optional(bool)
    security_group_id_map                    = map(string)
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

variable "vpc_availability_zone_map_key_list_default" {
  type        = list(string)
  default     = ["a", "b"]
  description = "AZs a, ... will be created for each key, mapped to these AWS AZs"
}

variable "vpc_dns64_enabled_default" {
  type        = bool
  default     = false
  description = "If true, AWS resolver will return IPv6-encoded results for local IPv4 addresses. Host resolvers prefer IPv6 per RFC, so without a 64:ff9b::/96 route to a NAT this will break connections to AWS services that do not support IPv6 - this route is handled automatically here. In the absence of mitigating measures, local traffic will also traverse the NAT. Enable with caution. Ignored unless nat_gateway_enabled."
}

variable "vpc_nacl_egress_map_default" {
  type = map(object({
    action          = string
    cidr_block      = string
    from_port       = number
    icmp_code       = number
    icmp_type       = number
    ipv6_cidr_block = string
    protocol        = string
    rule_number     = number
    to_port         = number
  }))
  default = {
    allow_ipv4 = {
      action          = "allow"
      cidr_block      = "0.0.0.0/0"
      from_port       = 0
      icmp_code       = null
      icmp_type       = null
      ipv6_cidr_block = null
      protocol        = "-1"
      rule_number     = 32100
      to_port         = 0
    }
    allow_ipv6 = {
      action          = "allow"
      cidr_block      = null
      from_port       = 0
      icmp_code       = null
      icmp_type       = null
      ipv6_cidr_block = "::/0"
      protocol        = "-1"
      rule_number     = 32200
      to_port         = 0
    }
  }
}

variable "vpc_nacl_ingress_map_default" {
  type = map(object({
    action          = string
    cidr_block      = string
    from_port       = number
    icmp_code       = number
    icmp_type       = number
    ipv6_cidr_block = string
    protocol        = string
    rule_number     = number
    to_port         = number
  }))
  default = {
    allow_rdp_10 = {
      action          = "allow"
      cidr_block      = "10.0.0.0/8"
      from_port       = 3389
      icmp_code       = null
      icmp_type       = null
      ipv6_cidr_block = null
      protocol        = "tcp"
      rule_number     = 10000
      to_port         = 3389
    }
    allow_rdp_172 = {
      action          = "allow"
      cidr_block      = "172.16.0.0/12"
      from_port       = 3389
      icmp_code       = null
      icmp_type       = null
      ipv6_cidr_block = null
      protocol        = "tcp"
      rule_number     = 10100
      to_port         = 3389
    }
    allow_rdp_192 = {
      action          = "allow"
      cidr_block      = "192.168.0.0/16"
      from_port       = 3389
      icmp_code       = null
      icmp_type       = null
      ipv6_cidr_block = null
      protocol        = "tcp"
      rule_number     = 10200
      to_port         = 3389
    }
    allow_ssh_10 = {
      action          = "allow"
      cidr_block      = "10.0.0.0/8"
      from_port       = 22
      icmp_code       = null
      icmp_type       = null
      ipv6_cidr_block = null
      protocol        = "tcp"
      rule_number     = 11000
      to_port         = 22
    }
    allow_ssh_172 = {
      action          = "allow"
      cidr_block      = "172.16.0.0/12"
      from_port       = 22
      icmp_code       = null
      icmp_type       = null
      ipv6_cidr_block = null
      protocol        = "tcp"
      rule_number     = 11100
      to_port         = 22
    }
    allow_ssh_192 = {
      action          = "allow"
      cidr_block      = "192.168.0.0/16"
      from_port       = 22
      icmp_code       = null
      icmp_type       = null
      ipv6_cidr_block = null
      protocol        = "tcp"
      rule_number     = 11200
      to_port         = 22
    }
    allow_tcp_v4_1 = {
      action          = "allow"
      cidr_block      = "0.0.0.0/0"
      from_port       = 0
      icmp_code       = null
      icmp_type       = null
      ipv6_cidr_block = null
      protocol        = "tcp"
      rule_number     = 30000
      to_port         = 21
    }
    allow_tcp_v4_2 = {
      action          = "allow"
      cidr_block      = "0.0.0.0/0"
      from_port       = 23
      icmp_code       = null
      icmp_type       = null
      ipv6_cidr_block = null
      protocol        = "tcp"
      rule_number     = 30100
      to_port         = 3388
    }
    allow_tcp_v4_3 = {
      action          = "allow"
      cidr_block      = "0.0.0.0/0"
      from_port       = 3390
      icmp_code       = null
      icmp_type       = null
      ipv6_cidr_block = null
      protocol        = "tcp"
      rule_number     = 30200
      to_port         = 65535
    }
    allow_udp_v4_1 = {
      action          = "allow"
      cidr_block      = "0.0.0.0/0"
      from_port       = 0
      icmp_code       = null
      icmp_type       = null
      ipv6_cidr_block = null
      protocol        = "udp"
      rule_number     = 30300
      to_port         = 21
    }
    allow_udp_v4_2 = {
      action          = "allow"
      cidr_block      = "0.0.0.0/0"
      from_port       = 23
      icmp_code       = null
      icmp_type       = null
      ipv6_cidr_block = null
      protocol        = "udp"
      rule_number     = 30400
      to_port         = 3388
    }
    allow_udp_v4_3 = {
      action          = "allow"
      cidr_block      = "0.0.0.0/0"
      from_port       = 3390
      icmp_code       = null
      icmp_type       = null
      ipv6_cidr_block = null
      protocol        = "udp"
      rule_number     = 30500
      to_port         = 65535
    }
    allow_tcp_v6_1 = {
      action          = "allow"
      cidr_block      = null
      from_port       = 0
      icmp_code       = null
      icmp_type       = null
      ipv6_cidr_block = "::/0"
      protocol        = "tcp"
      rule_number     = 31000
      to_port         = 21
    }
    allow_tcp_v6_2 = {
      action          = "allow"
      cidr_block      = null
      from_port       = 23
      icmp_code       = null
      icmp_type       = null
      ipv6_cidr_block = "::/0"
      protocol        = "tcp"
      rule_number     = 31100
      to_port         = 3388
    }
    allow_tcp_v6_3 = {
      action          = "allow"
      cidr_block      = null
      from_port       = 3390
      icmp_code       = null
      icmp_type       = null
      ipv6_cidr_block = "::/0"
      protocol        = "tcp"
      rule_number     = 31200
      to_port         = 65535
    }
    allow_udp_v6_1 = {
      action          = "allow"
      cidr_block      = null
      from_port       = 0
      icmp_code       = null
      icmp_type       = null
      ipv6_cidr_block = "::/0"
      protocol        = "udp"
      rule_number     = 31300
      to_port         = 21
    }
    allow_udp_v6_2 = {
      action          = "allow"
      cidr_block      = null
      from_port       = 23
      icmp_code       = null
      icmp_type       = null
      ipv6_cidr_block = "::/0"
      protocol        = "udp"
      rule_number     = 31400
      to_port         = 3388
    }
    allow_udp_v6_3 = {
      action          = "allow"
      cidr_block      = null
      from_port       = 3390
      icmp_code       = null
      icmp_type       = null
      ipv6_cidr_block = "::/0"
      protocol        = "udp"
      rule_number     = 31500
      to_port         = 65535
    }
    allow_icmp4 = {
      action          = "allow"
      cidr_block      = "0.0.0.0/0"
      from_port       = 0
      icmp_code       = -1
      icmp_type       = -1
      ipv6_cidr_block = null
      protocol        = "icmp"
      rule_number     = 32000
      to_port         = 0
    }
    allow_icmp6 = {
      action          = "allow"
      cidr_block      = null
      from_port       = 0
      icmp_code       = -1
      icmp_type       = -1
      ipv6_cidr_block = "::/0"
      protocol        = "ipv6-icmp"
      rule_number     = 32100
      to_port         = 0
    }
  }
  description = "Allowing ingress on 0.0.0.0/0 for SSH and RDP is a medium-level security finding. Using deny for this is futile as the Config rules do not account for it."
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

variable "vpc_public_subnet_assign_public_ip_on_launch_default" {
  type        = bool
  default     = false
  description = "A medium-severity security finding if enabled."
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
