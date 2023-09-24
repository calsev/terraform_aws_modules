variable "std_map" {
  type = object({
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}

variable "ttl_map" {
  type = object({
    ns = number
  })
}

variable "zone_list" {
  type = list(object({
    dns_zone_id_parent = string
    fqdn               = string
  }))
}
