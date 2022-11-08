variable "internal_cidr_blocks" {
  type    = list(string)
  default = null
}

variable "internal_ipv6_cidr_blocks" {
  type    = list(string)
  default = null
}

variable "rule_map_public" {
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
          cidr_blocks      = null
          from_port        = null
          ipv6_cidr_blocks = null
          protocol         = "-1"
          to_port          = null
          type             = "egress"
        }
      }
    }
    world_http_in = {
      rules = {
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
    world_ssh_in = {
      rules = {
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
    world_vpn_in = {
      rules = {
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

variable "rule_map_internal" {
  type = map(object({
    rules = map(object({
      from_port = optional(number)
      protocol  = optional(string)
      to_port   = optional(number)
      type      = optional(string)
    }))
  }))
  default = {
    internal_mysql_in = {
      rules = {
        mysql = {
          from_port = 3306
          protocol  = null
          to_port   = null
          type      = null
        }
      }
    }
  }
  description = "If CIDR block is provided, these will be created, with that CIDR inserted for each"
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
