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

{{ std.map() }}
