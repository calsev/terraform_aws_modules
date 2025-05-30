variable "allow_cloudtrail" {
  type    = bool
  default = true
}

variable "allow_iam_delegation" {
  type    = bool
  default = true
}

variable "key_id" {
  type = string
}

variable "policy_create" {
  type    = bool
  default = true
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
