variable "policy_map" {
  type = map(object({
    policy_attach_arn_map   = map(string)
    policy_create_json_map  = map(string)
    policy_inline_json_map  = map(string)
    policy_managed_name_map = map(string) # The short identifier of the managed policy, the part after 'arn:<iam_partition>:iam::aws:policy/'
  }))
}

variable "policy_attach_arn_map_default" {
  type    = map(string)
  default = {}
}

variable "policy_create_json_map_default" {
  type    = map(string)
  default = {}
}

variable "policy_inline_json_map_default" {
  type    = map(string)
  default = {}
}

variable "policy_managed_name_map_default" {
  type    = map(string)
  default = {}
}

variable "policy_name_infix_default" {
  type    = bool
  default = true
}

variable "policy_name_prefix_default" {
  type    = string
  default = ""
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
