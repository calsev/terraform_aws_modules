{{ std.map() }}

variable "vpc_map" {
  type = map(object({
    name_simple = string
    security_group_map = map(object({
      # This can be synthesized using module security_group_rule_set
      rule_map = map(object({
        cidr_blocks      = list(string)
        from_port        = number
        ipv6_cidr_blocks = list(string)
        protocol         = string
        to_port          = number
        type             = string
      }))
    }))
    vpc_id = string
  }))
}
