variable "dns_data" {
  type = object({
    domain_to_dns_zone_map = map(object({
      dns_zone_id = string
    }))
  })
}

variable "record_map" {
  type = map(object({
    dns_alias_name                   = optional(string)
    dns_alias_zone_id                = optional(string)
    dns_alias_evaluate_target_health = optional(bool)
    dns_from_zone_id                 = optional(string) # Overrides key lookup
    dns_from_zone_key                = optional(string)
    dns_from_fqdn                    = optional(string) # Defaults to name_simple
    dns_record_list                  = optional(list(string))
    dns_ttl_type_override            = optional(string)
    dns_type                         = optional(string)
  }))
}

variable "record_dns_alias_zone_id_default" {
  type    = string
  default = null
}

variable "record_dns_alias_evaluate_target_health_default" {
  type    = bool
  default = false
}

variable "record_dns_from_zone_key_default" {
  type    = string
  default = null
}

variable "record_dns_record_list_default" {
  type        = list(string)
  default     = []
  description = "Ignored for alias records"
}

variable "record_dns_ttl_type_override_default" {
  type    = string
  default = null
  validation {
    condition     = var.record_dns_ttl_type_override_default == null ? true : contains(["A", "AAAA", "CAA", "CNAME", "DS", "MX", "NAPTR", "NS", "PTR", "SOA", "SPF", "SRV", "TXT"], var.record_dns_ttl_type_override_default)
    error_message = "Invalid record type"
  }
}

variable "record_dns_type_default" {
  type    = string
  default = "A"
  validation {
    condition     = contains(["A", "AAAA", "CAA", "CNAME", "DS", "MX", "NAPTR", "NS", "PTR", "SOA", "SPF", "SRV", "TXT"], var.record_dns_type_default)
    error_message = "Invalid record type"
  }
}

variable "std_map" {
  type = object({
    name_replace_regex   = string
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}

variable "ttl_map" {
  type = map(number)
  default = {
    A     = 60 * 5           # IPv4
    AAA   = 60 * 5           # IPv6
    CAA   = 60 * 60 * 24 * 2 # Cert authorization
    CNAME = 60 * 60          # Canonical
    DS    = 60 * 60 * 24 * 2 # DNSSEC
    MX    = 60 * 10          # Email exchange
    NAPTR = 60 * 60          # Rewrite
    NS    = 60 * 60 * 24 * 2 # Nameservers
    PTR   = 60 * 5           # Final canonical (reverse)
    SOA   = 60 * 60 * 24 * 2 # DNS authority
    SPF   = 60 * 60          # Email authorization
    SRV   = 60 * 10          # Service record
    TXT   = 60 * 60          # Arbitrary
  }
  description = "A map of record type to time to live, in seconds. Ignored for alias records."
}
