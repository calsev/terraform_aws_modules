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
