variable "domain_map" {
  type = map(object({
    enable_transparency_logging = optional(bool)
    validation_domain           = optional(string)
  }))
}

variable "domain_enable_transparency_logging_default" {
  type    = bool
  default = true
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
    name_replace_regex   = string
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}
