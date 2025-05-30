variable "config_data_map" {
  type = map(object({
    configuration_set_name = string
  }))
  default     = null
  description = "Must be provided if any domain uses a default config"
}

variable "domain_map" {
  type = map(object({
    configuration_set_key    = optional(string)
    email_forwarding_enabled = optional(bool)
  }))
}

variable "domain_configuration_set_key_default" {
  type    = string
  default = null
}

variable "domain_email_forwarding_enabled_default" {
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
