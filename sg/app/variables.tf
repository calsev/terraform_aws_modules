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
  default     = {}
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
  default = {}
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
  default = {}
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
    name_replace_regex   = string
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}

variable "vpc_key" {
  type = string
}

variable "vpc_data_map" {
  # Add attributes as needed for a drop-in replacement
  type = map(object({
    name_simple           = string
    security_group_id_map = map(string)
    segment_map = map(object({
      route_public  = bool
      subnet_id_map = map(string)
    }))
    vpc_cidr_block      = string
    vpc_id              = string
    vpc_ipv6_cidr_block = string
  }))
}
