variable "name_map" {
  type = map(object({
    policy_create                  = optional(bool)
    policy_access_list             = optional(list(string))
    policy_name_append             = optional(string)
    policy_name_include_app_fields = optional(bool)
    policy_name_infix              = optional(bool)
    policy_name_override           = optional(string)
    policy_name_prefix             = optional(string)
    policy_name_prepend            = optional(string)
    policy_name_suffix             = optional(string)
  }))
}

variable "policy_access_list_default" {
  type = list(string)
  default = [
    "read",
    "read_write",
    "write",
  ]
}

variable "policy_create_default" {
  type    = bool
  default = true
}

variable "policy_name_append_default" {
  type    = string
  default = ""
}

variable "policy_name_prefix_default" {
  type    = string
  default = ""
}

# tflint-ignore: terraform_unused_declarations
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
