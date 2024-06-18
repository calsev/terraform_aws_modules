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
    active_directory_in = {
      # IPv6 not supported so not created for rule brevity
      # 339?
      rule_map = {
        ad_management = {
          cidr_blocks      = null
          from_port        = 9389
          ipv6_cidr_blocks = []
          protocol         = null
          to_port          = null
          type             = null
        }
        dns_tcp = {
          cidr_blocks      = null
          from_port        = 53
          ipv6_cidr_blocks = []
          protocol         = null
          to_port          = null
          type             = null
        }
        dns_udp = {
          cidr_blocks      = null
          from_port        = 53
          ipv6_cidr_blocks = []
          protocol         = "udp"
          to_port          = null
          type             = null
        }
        ephemeral_reply = {
          cidr_blocks      = null
          from_port        = 1024
          ipv6_cidr_blocks = []
          protocol         = null
          to_port          = 65535
          type             = null
        }
        icmp = {
          cidr_blocks      = null
          from_port        = -1
          ipv6_cidr_blocks = []
          protocol         = "icmp"
          to_port          = -1
          type             = null
        }
        kerberos_1_tcp = {
          cidr_blocks      = null
          from_port        = 88
          ipv6_cidr_blocks = []
          protocol         = null
          to_port          = null
          type             = null
        }
        kerberos_1_udp = {
          cidr_blocks      = null
          from_port        = 88
          ipv6_cidr_blocks = []
          protocol         = "udp"
          to_port          = null
          type             = null
        }
        kerberos_2_tcp = {
          cidr_blocks      = null
          from_port        = 464
          ipv6_cidr_blocks = []
          protocol         = null
          to_port          = null
          type             = null
        }
        kerberos_2_udp = {
          cidr_blocks      = null
          from_port        = 464
          ipv6_cidr_blocks = []
          protocol         = "udp"
          to_port          = null
          type             = null
        }
        ldap_1_tcp = {
          cidr_blocks      = null
          from_port        = 389
          ipv6_cidr_blocks = []
          protocol         = null
          to_port          = null
          type             = null
        }
        ldap_1_udp = {
          cidr_blocks      = null
          from_port        = 389
          ipv6_cidr_blocks = []
          protocol         = "udp"
          to_port          = null
          type             = null
        }
        ldap_2s = {
          cidr_blocks      = null
          from_port        = null
          ipv6_cidr_blocks = []
          protocol         = null
          to_port          = 636
          type             = null
        }
        ldap_3 = {
          cidr_blocks      = null
          from_port        = 3268
          ipv6_cidr_blocks = []
          protocol         = null
          to_port          = null
          type             = null
        }
        ldap_3s = {
          cidr_blocks      = null
          from_port        = null
          ipv6_cidr_blocks = []
          protocol         = null
          to_port          = 3269
          type             = null
        }
        netbios_name = {
          cidr_blocks      = null
          from_port        = 138
          ipv6_cidr_blocks = []
          protocol         = "udp"
          to_port          = null
          type             = null
        }
        rpc_mapper = {
          cidr_blocks      = null
          from_port        = 135
          ipv6_cidr_blocks = []
          protocol         = null
          to_port          = null
          type             = null
        }
        smb_tcp = {
          cidr_blocks      = null
          from_port        = 445
          ipv6_cidr_blocks = []
          protocol         = null
          to_port          = null
          type             = null
        }
        smb_udp = {
          cidr_blocks      = null
          from_port        = 445
          ipv6_cidr_blocks = []
          protocol         = "udp"
          to_port          = null
          type             = null
        }
        win_32_time = {
          cidr_blocks      = null
          from_port        = 123
          ipv6_cidr_blocks = []
          protocol         = "udp"
          to_port          = null
          type             = null
        }
      }
    }
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
    http_alt_in = {
      rule_map = {
        http = {
          cidr_blocks      = null
          from_port        = 8080
          ipv6_cidr_blocks = null
          protocol         = null
          to_port          = null
          type             = null
        }
        https = {
          cidr_blocks      = null
          from_port        = 8443
          ipv6_cidr_blocks = null
          protocol         = null
          to_port          = null
          type             = null
        }
      }
    }
    memcached_in = {
      rule_map = {
        memcached = {
          cidr_blocks      = null
          from_port        = 11211
          ipv6_cidr_blocks = null
          protocol         = null
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
    rdp_in = {
      rule_map = {
        tcp = {
          cidr_blocks      = null
          from_port        = 3389
          ipv6_cidr_blocks = null
          protocol         = null
          to_port          = null
          type             = null
        }
        udp = {
          cidr_blocks      = null
          from_port        = 3389
          ipv6_cidr_blocks = null
          protocol         = "udp"
          to_port          = null
          type             = null
        }
      }
    }
    redis_in = {
      rule_map = {
        redis = {
          cidr_blocks      = null
          from_port        = 6379
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
        # http - critical security violation
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
    # http_alt_in: http - critical security violation, https - high security violation
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
    # ssh_in - critical security violation
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
