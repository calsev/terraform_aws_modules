variable "dns_data" {
  type = object({
    domain_to_dns_zone_map = map(object({
      dns_zone_id = string
    }))
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

variable "zone_map" {
  type = map(object({
    dns_from_zone_key = string
  }))
}

variable "zone_dns_from_zone_key_default" {
  type    = string
  default = null
}
