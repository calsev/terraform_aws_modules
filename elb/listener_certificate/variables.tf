variable "dns_data" {
  type = object({
    domain_to_dns_zone_map = map(object({
      dns_zone_id = string
    }))
    region_domain_cert_map = map(map(object({
      certificate_arn = string
      name_simple     = string
    })))
  })
}

variable "elb_data_map" {
  type = map(object({
    elb_dns_name    = string
    elb_dns_zone_id = string
  }))
}

variable "listener_map" {
  type = map(object({
    acm_certificate_key     = string # If null, no cert will be created
    dns_alias_enabled       = optional(bool)
    dns_alias_fqdn          = optional(string) # Defaults to DNS name of certificate
    elb_key                 = string
    elb_listener_arn        = optional(string)
    dns_from_zone_key       = optional(string)
    is_listener             = optional(bool)
    name_append             = optional(string)
    name_include_app_fields = optional(bool)
    name_infix              = optional(bool)
    name_prefix             = optional(string)
    name_prepend            = optional(string)
    name_suffix             = optional(string)
  }))
}

variable "listener_acm_certificate_key_default" {
  type    = string
  default = null
}

variable "listener_dns_alias_enabled_default" {
  type    = bool
  default = true
}

variable "listener_dns_from_zone_key_default" {
  type    = string
  default = null
}

variable "listener_elb_listener_arn_default" {
  type    = string
  default = null
}

variable "listener_is_listener_default" {
  type        = bool
  default     = false
  description = "Listeners and rules are abstracted by the listener module. This flag indicates it is a listener."
}

variable "name_append_default" {
  type        = string
  default     = ""
  description = "Appended after key"
}

variable "name_include_app_fields_default" {
  type        = bool
  default     = true
  description = "If true, standard project context will be prefixed to the name. Ignored if not name_infix."
}

variable "name_infix_default" {
  type        = bool
  default     = true
  description = "If true, standard project prefix and resource suffix will be added to the name"
}

variable "name_prefix_default" {
  type        = string
  default     = ""
  description = "Prepended before context prefix"
}

variable "name_prepend_default" {
  type        = string
  default     = ""
  description = "Prepended before key"
}

# tflint-ignore: terraform_unused_declarations
variable "name_regex_allow_list" {
  type        = list(string)
  default     = []
  description = "By default, all punctuation is replaced by -"
}

variable "name_suffix_default" {
  type        = string
  default     = ""
  description = "Appended after context suffix"
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
