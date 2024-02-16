variable "domain_to_dns_zone_map" {
  type = map(object({
    mx_url_list = optional(list(string))
  }))
}

variable "domain_mx_url_list_default" {
  type        = list(string)
  default     = null
  description = "Set to null to disable MX records"
}

variable "ttl_mx" {
  type    = number
  default = 3600
}
