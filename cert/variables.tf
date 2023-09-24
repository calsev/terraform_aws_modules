variable "domain_map" {
  type = map(object({
    validation_domain = optional(string)
  }))
}

variable "domain_validation_domain_default" {
  type    = string
  default = null
}

variable "dns_data" {
  type = object({
    domain_to_dns_zone_map = map(object({
      dns_zone_id = string
    }))
    ttl_map = object({
      challenge = number
    })
  })
}

variable "std_map" {
  type = object({
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}
