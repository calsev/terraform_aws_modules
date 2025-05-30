variable "dns_data" {
  type = object({
    domain_to_dns_zone_map = map(object({
      dns_zone_id = string
    }))
    region_domain_cert_map = map(map(object({
      certificate_arn = string
    })))
  })
  default     = null
  description = "Must be provided if any stage has a DNS mapping"
}

variable "domain_map" {
  type = map(object({
    dns_from_fqdn     = optional(string) # Defaults to name_simple
    dns_from_zone_key = optional(string)
  }))
  default = {}
}

variable "domain_dns_from_zone_key_default" {
  type    = string
  default = null
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
