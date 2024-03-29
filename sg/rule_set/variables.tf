variable "cidr_blocks_internal" {
  type        = list(string)
  default     = ["10.0.0.0/8"]
  description = "Set null to disable internal security groups"
}

variable "cidr_blocks_internal_ipv6" {
  type        = list(string)
  default     = null
  description = "Defaults to IPV6 CIDR blocks of all VPCs. Set to empty list to bootstrap a new VPC."
}

variable "cidr_blocks_public" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "cidr_blocks_public_ipv6" {
  type    = list(string)
  default = ["::/0"]
}

variable "cidr_blocks_private" {
  type        = list(string)
  default     = null
  description = "Set null to disable private security groups"
}

variable "cidr_blocks_private_ipv6" {
  type    = list(string)
  default = null
}

variable "sg_map_internal" {
  type = map(object({
    rule_map = map(object({
      cidr_blocks      = optional(list(string))
      from_port        = optional(number)
      ipv6_cidr_blocks = optional(list(string))
      protocol         = optional(string)
      to_port          = optional(number)
      type             = optional(string)
    }))
  }))
  default = {
    all_in = {
      rule_map = {
        all = {
          cidr_blocks      = null
          from_port        = null
          ipv6_cidr_blocks = null
          protocol         = "-1"
          to_port          = null
          type             = null
        }
      }
    }
    mongodb_in = {
      rule_map = {
        mongodb = {
          cidr_blocks      = null
          from_port        = 27017
          ipv6_cidr_blocks = null
          protocol         = null
          to_port          = null
          type             = null
        }
      }
    }
    mysql_in = {
      rule_map = {
        mysql = {
          cidr_blocks      = null
          from_port        = 3306
          ipv6_cidr_blocks = null
          protocol         = null
          to_port          = null
          type             = null
        }
      }
    }
    nfs_in = {
      rule_map = {
        nfs = {
          cidr_blocks      = null
          from_port        = 2049
          ipv6_cidr_blocks = null
          protocol         = null
          to_port          = null
          type             = null
        }
      }
    }
    postgres_in = {
      rule_map = {
        postgres = {
          cidr_blocks      = null
          from_port        = 5432
          ipv6_cidr_blocks = null
          protocol         = null
          to_port          = null
          type             = null
        }
      }
    }
    ssh_in = {
      rule_map = {
        ssh = {
          cidr_blocks      = null
          from_port        = 22
          ipv6_cidr_blocks = null
          protocol         = null
          to_port          = null
          type             = null
        }
      }
    }
  }
  description = "If CIDR block is provided, these will be created, with that CIDR inserted for each"
}

variable "sg_map_public" {
  type = map(object({
    rule_map = map(object({
      cidr_blocks      = optional(list(string))
      from_port        = optional(number)
      ipv6_cidr_blocks = optional(list(string))
      protocol         = optional(string)
      to_port          = optional(number)
      type             = optional(string)
    }))
  }))
  default = {
    all_out = {
      rule_map = {
        all = {
          cidr_blocks      = null
          from_port        = null
          ipv6_cidr_blocks = null
          protocol         = "-1"
          to_port          = null
          type             = "egress"
        }
      }
    }
    http_in = {
      rule_map = {
        http = {
          cidr_blocks      = null
          from_port        = 80
          ipv6_cidr_blocks = null
          protocol         = null
          to_port          = null
          type             = null
        }
        https = {
          cidr_blocks      = null
          from_port        = 443
          ipv6_cidr_blocks = null
          protocol         = null
          to_port          = null
          type             = null
        }
      }
    }
    icmp_in = {
      rule_map = {
        icmp = {
          cidr_blocks      = null
          from_port        = -1
          ipv6_cidr_blocks = []
          protocol         = "icmp"
          to_port          = -1
          type             = null
        }
        icmp_v6 = {
          cidr_blocks      = []
          from_port        = -1
          ipv6_cidr_blocks = null
          protocol         = "icmpv6"
          to_port          = -1
          type             = null
        }
      }
    }
    open_vpn_in = {
      rule_map = {
        web = {
          cidr_blocks      = null
          from_port        = 943
          ipv6_cidr_blocks = null
          protocol         = null
          to_port          = null
          type             = null
        }
        api = {
          cidr_blocks      = null
          from_port        = 945
          ipv6_cidr_blocks = null
          protocol         = null
          to_port          = null
          type             = null
        }
        daemon = {
          cidr_blocks      = null
          from_port        = 1194
          ipv6_cidr_blocks = null
          protocol         = "udp"
          to_port          = null
          type             = null
        }
      }
    }
    ssh_in = {
      rule_map = {
        ssh = {
          cidr_blocks      = null
          from_port        = 22
          ipv6_cidr_blocks = null
          protocol         = null
          to_port          = null
          type             = null
        }
      }
    }
    vpn_in = {
      rule_map = {
        vpn = {
          cidr_blocks      = null
          from_port        = 1194
          ipv6_cidr_blocks = null
          protocol         = "udp"
          to_port          = null
          type             = null
        }
      }
    }
  }
}

variable "sg_map_private" {
  type = map(object({
    rule_map = map(object({
      cidr_blocks      = optional(list(string))
      from_port        = optional(number)
      ipv6_cidr_blocks = optional(list(string))
      protocol         = optional(string)
      to_port          = optional(number)
      type             = optional(string)
    }))
  }))
  default     = null
  description = "By default, internal rules will be used"
}

variable "security_group_from_port_default" {
  type    = number
  default = 0
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

variable "std_map" {
  type = object({
    name_replace_regex = string
  })
}

variable "vpc_map" {
  type = map(object({
    vpc_ipv6_cidr_block = string
  }))
  default     = null
  description = "Must be provided if any private security group uses default ipv6 cidr blocks"
}
