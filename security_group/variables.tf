variable "security_group_map" {
  type = map(object({
    rules = map(object({
      cidr_blocks      = list(string)
      from_port        = number
      ipv6_cidr_blocks = list(string)
      protocol         = string
      to_port          = number
      type             = string
    }))
  }))
  description = "This can be synthesized using module security_group_rule_set"
}

variable "std_map" {
  type = object({
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}

variable "vpc_data" {
  type = object({
    vpc_id   = string
    vpc_name = string
  })
}
