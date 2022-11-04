variable "std_map" {
  type = object({
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}

variable "vpc_data" {
  type = object({
    security_group_map = optional(map(object({
      rules = map(object({
        cidr_blocks      = optional(list(string))
        from_port        = optional(number)
        ipv6_cidr_blocks = optional(list(string))
        protocol         = optional(string)
        to_port          = optional(number)
        type             = optional(string)
      }))
    })))
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

variable "security_group_map_default" {
  type = map(object({
    rules = map(object({
      cidr_blocks      = optional(list(string))
      from_port        = optional(number)
      ipv6_cidr_blocks = optional(list(string))
      protocol         = optional(string)
      to_port          = optional(number)
      type             = optional(string)
    }))
  }))
  default = {
    world_all_out = {
      rules = {
        all = {
          protocol = "-1"
          type     = "egress"
        }
      }
    }
    world_http_in = {
      rules = {
        http = {
          from_port = 80
        }
        https = {
          from_port = 443
        }
      }
    }
    world_ssh_in = {
      rules = {
        ssh = {
          from_port = 22
        }
      }
    }
    world_vpn_in = {
      rules = {
        vpn = {
          from_port = 1194
          protocol  = "udp"
        }
      }
    }
  }
}

variable "security_group_cidr_blocks_default" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "security_group_from_port_default" {
  type    = number
  default = 0
}

variable "security_group_ipv6_cidr_blocks_default" {
  type    = list(string)
  default = ["::/0"]
}

variable "security_group_protocol_default" {
  type    = string
  default = "tcp"
}

variable "security_group_to_port_default" {
  type    = number
  default = 65535
}

variable "security_group_type_default" {
  type    = string
  default = "ingress"
}

variable "vpc_name" {
  type = string
}
