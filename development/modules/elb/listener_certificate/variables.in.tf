variable "dns_data" {
  type = object({
    domain_to_dns_zone_map = map(object({
      dns_zone_id = string
    }))
    region_domain_cert_map = map(map(object({
      certificate_arn = string
      name_simple     = string
    })))
  })
}

variable "elb_data_map" {
  type = map(object({
    elb_dns_name    = string
    elb_dns_zone_id = string
  }))
}

variable "listener_map" {
  type = map(object({
    acm_certificate_key     = string # If null, no cert will be created
    dns_alias_enabled       = optional(bool)
    dns_alias_fqdn          = optional(string) # Defaults to DNS name of certificate
    elb_key                 = string
    elb_listener_arn        = optional(string)
    dns_from_zone_key       = optional(string)
    is_listener             = optional(bool)
    {{ name.var_item() }}
  }))
}

variable "listener_acm_certificate_key_default" {
  type    = string
  default = null
}

variable "listener_dns_alias_enabled_default" {
  type    = bool
  default = true
}

variable "listener_dns_from_zone_key_default" {
  type    = string
  default = null
}

variable "listener_elb_listener_arn_default" {
  type    = string
  default = null
}

variable "listener_is_listener_default" {
  type        = bool
  default     = false
  description = "Listeners and rules are abstracted by the listener module. This flag indicates it is a listener."
}

{{ name.var() }}

{{ std.map() }}
