variable "service_name" {
  type = string
}

variable "sid_map" {
  type = map(object({
    access = string
    condition_map = map(object({
      test       = string
      value_list = list(string)
      variable   = string
    }))
    identifier_list = optional(list(string))
    identifier_type = optional(string)
    resource_list   = optional(list(string))
    resource_type   = string
    sid             = string
  }))
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
