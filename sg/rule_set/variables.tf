variable "cidr_blocks_internal" {
  type        = list(string)
  default     = ["10.0.0.0/8"]
  description = "Set null to disable internal security groups. Ignored for any rule with source specified."
}

variable "cidr_blocks_internal_ipv6" {
  type        = list(string)
  default     = null
  description = "Defaults to IPV6 CIDR blocks of all VPCs. Set to empty list to bootstrap a new VPC. Ignored for any rule with source specified."
}

variable "cidr_blocks_public" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = "Ignored for any rule with source specified."
}

variable "cidr_blocks_public_ipv6" {
  type        = list(string)
  default     = ["::/0"]
  description = "Ignored for any rule with source specified."
}

variable "cidr_blocks_private" {
  type        = list(string)
  default     = []
  description = "Set null to disable private security groups. Ignored for any rule with source specified."
}

variable "cidr_blocks_private_ipv6" {
  type        = list(string)
  default     = null
  description = "Ignored for any rule with source specified."
}

variable "sg_map_internal" {
  type = map(object({
    revoke_rules_on_delete = optional(bool, false)
    rule_map = map(object({
      cidr_blocks              = optional(list(string))
      from_port                = optional(number)
      ipv6_cidr_blocks         = optional(list(string))
      prefix_id_list           = optional(list(string), null)
      protocol                 = optional(string)
      to_port                  = optional(number)
      source_is_self           = optional(bool, null)
      source_security_group_id = optional(string, null)
      type                     = optional(string)
    }))
  }))
  default = {
    active_directory_in = {
      # IPv6 not supported so not created for rule brevity
      # 339?
      revoke_rules_on_delete = false
      rule_map = {
        ad_management = {
          cidr_blocks              = null
          from_port                = 9389
          ipv6_cidr_blocks         = []
          prefix_id_list           = null
          protocol                 = null
          source_is_self           = null
          source_security_group_id = null
          to_port                  = null
          type                     = null
        }
        dns_tcp = {
          cidr_blocks              = null
          from_port                = 53
          ipv6_cidr_blocks         = []
          prefix_id_list           = null
          protocol                 = null
          source_is_self           = null
          source_security_group_id = null
          to_port                  = null
          type                     = null
        }
        dns_udp = {
          cidr_blocks              = null
          from_port                = 53
          ipv6_cidr_blocks         = []
          prefix_id_list           = null
          protocol                 = "udp"
          source_is_self           = null
          source_security_group_id = null
          to_port                  = null
          type                     = null
        }
        ephemeral_reply = {
          cidr_blocks              = null
          from_port                = 1024
          ipv6_cidr_blocks         = []
          prefix_id_list           = null
          protocol                 = null
          source_is_self           = null
          source_security_group_id = null
          to_port                  = 65535
          type                     = null
        }
        icmp = {
          cidr_blocks              = null
          from_port                = -1
          ipv6_cidr_blocks         = []
          prefix_id_list           = null
          protocol                 = "icmp"
          source_is_self           = null
          source_security_group_id = null
          to_port                  = -1
          type                     = null
        }
        kerberos_1_tcp = {
          cidr_blocks              = null
          from_port                = 88
          ipv6_cidr_blocks         = []
          prefix_id_list           = null
          protocol                 = null
          source_is_self           = null
          source_security_group_id = null
          to_port                  = null
          type                     = null
        }
        kerberos_1_udp = {
          cidr_blocks              = null
          from_port                = 88
          ipv6_cidr_blocks         = []
          prefix_id_list           = null
          protocol                 = "udp"
          source_is_self           = null
          source_security_group_id = null
          to_port                  = null
          type                     = null
        }
        kerberos_2_tcp = {
          cidr_blocks              = null
          from_port                = 464
          ipv6_cidr_blocks         = []
          prefix_id_list           = null
          protocol                 = null
          source_is_self           = null
          source_security_group_id = null
          to_port                  = null
          type                     = null
        }
        kerberos_2_udp = {
          cidr_blocks              = null
          from_port                = 464
          ipv6_cidr_blocks         = []
          prefix_id_list           = null
          protocol                 = "udp"
          source_is_self           = null
          source_security_group_id = null
          to_port                  = null
          type                     = null
        }
        ldap_1_tcp = {
          cidr_blocks              = null
          from_port                = 389
          ipv6_cidr_blocks         = []
          prefix_id_list           = null
          protocol                 = null
          source_is_self           = null
          source_security_group_id = null
          to_port                  = null
          type                     = null
        }
        ldap_1_udp = {
          cidr_blocks              = null
          from_port                = 389
          ipv6_cidr_blocks         = []
          prefix_id_list           = null
          protocol                 = "udp"
          source_is_self           = null
          source_security_group_id = null
          to_port                  = null
          type                     = null
        }
        ldap_2s = {
          cidr_blocks              = null
          from_port                = null
          ipv6_cidr_blocks         = []
          prefix_id_list           = null
          protocol                 = null
          source_is_self           = null
          source_security_group_id = null
          to_port                  = 636
          type                     = null
        }
        ldap_3 = {
          cidr_blocks              = null
          from_port                = 3268
          ipv6_cidr_blocks         = []
          prefix_id_list           = null
          protocol                 = null
          source_is_self           = null
          source_security_group_id = null
          to_port                  = null
          type                     = null
        }
        ldap_3s = {
          cidr_blocks              = null
          from_port                = null
          ipv6_cidr_blocks         = []
          prefix_id_list           = null
          protocol                 = null
          source_is_self           = null
          source_security_group_id = null
          to_port                  = 3269
          type                     = null
        }
        netbios_name = {
          cidr_blocks              = null
          from_port                = 138
          ipv6_cidr_blocks         = []
          prefix_id_list           = null
          protocol                 = "udp"
          source_is_self           = null
          source_security_group_id = null
          to_port                  = null
          type                     = null
        }
        rpc_mapper = {
          cidr_blocks              = null
          from_port                = 135
          ipv6_cidr_blocks         = []
          prefix_id_list           = null
          protocol                 = null
          source_is_self           = null
          source_security_group_id = null
          to_port                  = null
          type                     = null
        }
        smb_tcp = {
          cidr_blocks              = null
          from_port                = 445
          ipv6_cidr_blocks         = []
          prefix_id_list           = null
          protocol                 = null
          source_is_self           = null
          source_security_group_id = null
          to_port                  = null
          type                     = null
        }
        smb_udp = {
          cidr_blocks              = null
          from_port                = 445
          ipv6_cidr_blocks         = []
          prefix_id_list           = null
          protocol                 = "udp"
          source_is_self           = null
          source_security_group_id = null
          to_port                  = null
          type                     = null
        }
        win_32_time = {
          cidr_blocks              = null
          from_port                = 123
          ipv6_cidr_blocks         = []
          prefix_id_list           = null
          protocol                 = "udp"
          source_is_self           = null
          source_security_group_id = null
          to_port                  = null
          type                     = null
        }
      }
    }
    all_in = {
      revoke_rules_on_delete = false
      rule_map = {
        all = {
          cidr_blocks              = null
          from_port                = null
          ipv6_cidr_blocks         = null
          prefix_id_list           = null
          protocol                 = "-1"
          source_is_self           = null
          source_security_group_id = null
          to_port                  = null
          type                     = null
        }
      }
    }
    bolt_in = {
      revoke_rules_on_delete = false
      rule_map = {
        bolt = {
          cidr_blocks              = null
          from_port                = 7687
          ipv6_cidr_blocks         = null
          prefix_id_list           = null
          protocol                 = null
          source_is_self           = null
          source_security_group_id = null
          to_port                  = null
          type                     = null
        }
      }
    }
    bolt_alt_in = {
      revoke_rules_on_delete = false
      rule_map = {
        bolt = {
          cidr_blocks              = null
          from_port                = 7688
          ipv6_cidr_blocks         = null
          prefix_id_list           = null
          protocol                 = null
          source_is_self           = null
          source_security_group_id = null
          to_port                  = null
          type                     = null
        }
      }
    }
    http_in = {
      revoke_rules_on_delete = false
      rule_map = {
        http = {
          cidr_blocks              = null
          from_port                = 80
          ipv6_cidr_blocks         = null
          prefix_id_list           = null
          protocol                 = null
          source_is_self           = null
          source_security_group_id = null
          to_port                  = null
          type                     = null
        }
        https = {
          cidr_blocks              = null
          from_port                = 443
          ipv6_cidr_blocks         = null
          prefix_id_list           = null
          protocol                 = null
          source_is_self           = null
          source_security_group_id = null
          to_port                  = null
          type                     = null
        }
      }
    }
    http_alt_in = {
      revoke_rules_on_delete = false
      rule_map = {
        http = {
          cidr_blocks              = null
          from_port                = 8080
          ipv6_cidr_blocks         = null
          prefix_id_list           = null
          protocol                 = null
          source_is_self           = null
          source_security_group_id = null
          to_port                  = null
          type                     = null
        }
        https = {
          cidr_blocks              = null
          from_port                = 8443
          ipv6_cidr_blocks         = null
          prefix_id_list           = null
          protocol                 = null
          source_is_self           = null
          source_security_group_id = null
          to_port                  = null
          type                     = null
        }
      }
    }
    memcached_in = {
      revoke_rules_on_delete = false
      rule_map = {
        memcached = {
          cidr_blocks              = null
          from_port                = 11211
          ipv6_cidr_blocks         = null
          prefix_id_list           = null
          protocol                 = null
          source_is_self           = null
          source_security_group_id = null
          to_port                  = null
          type                     = null
        }
      }
    }
    mongodb_in = {
      revoke_rules_on_delete = false
      rule_map = {
        mongodb = {
          cidr_blocks              = null
          from_port                = 27017
          ipv6_cidr_blocks         = null
          prefix_id_list           = null
          protocol                 = null
          source_is_self           = null
          source_security_group_id = null
          to_port                  = null
          type                     = null
        }
      }
    }
    mysql_in = {
      revoke_rules_on_delete = false
      rule_map = {
        mysql = {
          cidr_blocks              = null
          from_port                = 3306
          ipv6_cidr_blocks         = null
          prefix_id_list           = null
          protocol                 = null
          source_is_self           = null
          source_security_group_id = null
          to_port                  = null
          type                     = null
        }
      }
    }
    nfs_in = {
      revoke_rules_on_delete = false
      rule_map = {
        nfs = {
          cidr_blocks              = null
          from_port                = 2049
          ipv6_cidr_blocks         = null
          prefix_id_list           = null
          protocol                 = null
          source_is_self           = null
          source_security_group_id = null
          to_port                  = null
          type                     = null
        }
      }
    }
    open_vpn_in = {
      revoke_rules_on_delete = false
      rule_map = {
        web = {
          cidr_blocks              = null
          from_port                = 943
          ipv6_cidr_blocks         = null
          prefix_id_list           = null
          protocol                 = null
          source_is_self           = null
          source_security_group_id = null
          to_port                  = null
          type                     = null
        }
        api = {
          cidr_blocks              = null
          from_port                = 945
          ipv6_cidr_blocks         = null
          prefix_id_list           = null
          protocol                 = null
          source_is_self           = null
          source_security_group_id = null
          to_port                  = null
          type                     = null
        }
        daemon = {
          cidr_blocks              = null
          from_port                = 1194
          ipv6_cidr_blocks         = null
          prefix_id_list           = null
          protocol                 = "udp"
          source_is_self           = null
          source_security_group_id = null
          to_port                  = null
          type                     = null
        }
      }
    }
    postgres_in = {
      revoke_rules_on_delete = false
      rule_map = {
        postgres = {
          cidr_blocks              = null
          from_port                = 5432
          ipv6_cidr_blocks         = null
          prefix_id_list           = null
          protocol                 = null
          source_is_self           = null
          source_security_group_id = null
          to_port                  = null
          type                     = null
        }
      }
    }
    rdp_in = {
      revoke_rules_on_delete = false
      rule_map = {
        tcp = {
          cidr_blocks              = null
          from_port                = 3389
          ipv6_cidr_blocks         = null
          prefix_id_list           = null
          protocol                 = null
          source_is_self           = null
          source_security_group_id = null
          to_port                  = null
          type                     = null
        }
        udp = {
          cidr_blocks              = null
          from_port                = 3389
          ipv6_cidr_blocks         = null
          prefix_id_list           = null
          protocol                 = "udp"
          source_is_self           = null
          source_security_group_id = null
          to_port                  = null
          type                     = null
        }
      }
    }
    redis_in = {
      revoke_rules_on_delete = false
      rule_map = {
        redis = {
          cidr_blocks              = null
          from_port                = 6379
          ipv6_cidr_blocks         = null
          prefix_id_list           = null
          protocol                 = null
          source_is_self           = null
          source_security_group_id = null
          to_port                  = null
          type                     = null
        }
      }
    }
    ssh_in = {
      revoke_rules_on_delete = false
      rule_map = {
        ssh = {
          cidr_blocks              = null
          from_port                = 22
          ipv6_cidr_blocks         = null
          prefix_id_list           = null
          protocol                 = null
          source_is_self           = null
          source_security_group_id = null
          to_port                  = null
          type                     = null
        }
      }
    }
  }
  description = "If CIDR block is provided, these will be created, with that CIDR inserted for each"
}

variable "sg_map_public" {
  type = map(object({
    revoke_rules_on_delete = optional(bool, false)
    rule_map = map(object({
      cidr_blocks              = optional(list(string))
      from_port                = optional(number)
      ipv6_cidr_blocks         = optional(list(string))
      prefix_id_list           = optional(list(string), null)
      protocol                 = optional(string)
      to_port                  = optional(number)
      source_is_self           = optional(bool, null)
      source_security_group_id = optional(string, null)
      type                     = optional(string)
    }))
  }))
  default = {
    all_out = {
      revoke_rules_on_delete = false
      rule_map = {
        all = {
          cidr_blocks              = null
          from_port                = null
          ipv6_cidr_blocks         = null
          prefix_id_list           = null
          protocol                 = "-1"
          source_is_self           = null
          source_security_group_id = null
          to_port                  = null
          type                     = "egress"
        }
      }
    }
    http_in = {
      revoke_rules_on_delete = false
      rule_map = {
        # http - critical security violation
        https = {
          cidr_blocks              = null
          from_port                = 443
          ipv6_cidr_blocks         = null
          prefix_id_list           = null
          protocol                 = null
          source_is_self           = null
          source_security_group_id = null
          to_port                  = null
          type                     = null
        }
      }
    }
    # http_alt_in: http - critical security violation, https - high security violation
    icmp_in = {
      revoke_rules_on_delete = false
      rule_map = {
        icmp = {
          cidr_blocks              = null
          from_port                = -1
          ipv6_cidr_blocks         = []
          prefix_id_list           = null
          protocol                 = "icmp"
          source_is_self           = null
          source_security_group_id = null
          to_port                  = -1
          type                     = null
        }
        icmp_v6 = {
          cidr_blocks              = []
          from_port                = -1
          ipv6_cidr_blocks         = null
          prefix_id_list           = null
          protocol                 = "icmpv6"
          source_is_self           = null
          source_security_group_id = null
          to_port                  = -1
          type                     = null
        }
      }
    }
    open_vpn_in = {
      revoke_rules_on_delete = false
      rule_map = {
        web = {
          cidr_blocks              = null
          from_port                = 943
          ipv6_cidr_blocks         = null
          prefix_id_list           = null
          protocol                 = null
          source_is_self           = null
          source_security_group_id = null
          to_port                  = null
          type                     = null
        }
        api = {
          cidr_blocks              = null
          from_port                = 945
          ipv6_cidr_blocks         = null
          prefix_id_list           = null
          protocol                 = null
          source_is_self           = null
          source_security_group_id = null
          to_port                  = null
          type                     = null
        }
        daemon = {
          cidr_blocks              = null
          from_port                = 1194
          ipv6_cidr_blocks         = null
          prefix_id_list           = null
          protocol                 = "udp"
          source_is_self           = null
          source_security_group_id = null
          to_port                  = null
          type                     = null
        }
      }
    }
    # ssh_in - critical security violation
  }
}

variable "sg_map_private" {
  type = map(object({
    revoke_rules_on_delete = optional(bool, false)
    rule_map = map(object({
      cidr_blocks              = optional(list(string))
      from_port                = optional(number)
      ipv6_cidr_blocks         = optional(list(string))
      prefix_id_list           = optional(list(string), null)
      protocol                 = optional(string)
      to_port                  = optional(number)
      source_is_self           = optional(bool, null)
      source_security_group_id = optional(string, null)
      type                     = optional(string)
    }))
  }))
  default = {
    self_tcp_in = {
      revoke_rules_on_delete = false
      rule_map = {
        tcp = {
          cidr_blocks              = null
          from_port                = 0
          ipv6_cidr_blocks         = null
          prefix_id_list           = null
          protocol                 = null
          source_is_self           = true
          source_security_group_id = null
          to_port                  = 65535
          type                     = null
        }
      }
    }
  }
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
    vpc_ipv6_cidr_block = string
  }))
  default     = null
  description = "Must be provided if any private security group uses default ipv6 cidr blocks"
}
