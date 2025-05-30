variable "domain_map" {
  type = map(object({
    enable_transparency_logging   = optional(bool)
    dns_from_zone_key             = optional(string)
    key_algorithm                 = optional(string)
    subject_alternative_name_list = optional(list(string), [])
  }))
}

variable "domain_enable_transparency_logging_default" {
  type    = bool
  default = true
}

variable "domain_dns_from_zone_key_default" {
  type    = string
  default = null
}

variable "domain_key_algorithm_default" {
  type        = string
  default     = "RSA_2048"
  description = "See https://docs.aws.amazon.com/acm/latest/userguide/acm-certificate.html#algorithms"
}

variable "dns_data" {
  type = object({
    domain_to_dns_zone_map = map(object({
      dns_zone_id = string
    }))
  })
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
