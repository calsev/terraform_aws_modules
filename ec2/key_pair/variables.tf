variable "key_map" {
  type = map(object({
    name_include_app_fields = optional(bool)
    name_infix              = optional(bool)
    secret_is_param         = optional(bool)
  }))
}

variable "key_secret_is_param_default" {
  type    = bool
  default = false
}

variable "key_name_include_app_fields_default" {
  type    = bool
  default = true
}

variable "key_name_infix_default" {
  type    = bool
  default = true
}

variable "std_map" {
  type = object({
    access_title_map               = map(string)
    aws_account_id                 = string
    aws_region_name                = string
    iam_partition                  = string
    name_replace_regex             = string
    resource_name_prefix           = string
    resource_name_suffix           = string
    service_resource_access_action = map(map(map(list(string))))
    tags                           = map(string)
  })
}
