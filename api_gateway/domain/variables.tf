variable "dns_data" {
  type = object({
    domain_to_dns_zone_map = map(object({
      dns_zone_id = string
    }))
    region_domain_cert_map = map(map(object({
      arn = string
    })))
    ttl_map = object({
      challenge = number
    })
  })
  default     = null
  description = "Must be provided if any stage has a DNS mapping"
}

variable "domain_map" {
  type = map(object({
    validation_domain = optional(string)
  }))
  default = {}
}

variable "domain_validation_domain_default" {
  type    = string
  default = null
}

variable "std_map" {
  type = object({
    aws_region_name      = string
    name_replace_regex   = string
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}
