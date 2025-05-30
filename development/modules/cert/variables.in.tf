variable "domain_map" {
  type = map(object({
    enable_transparency_logging   = optional(bool)
    dns_from_zone_key             = optional(string)
    key_algorithm                 = optional(string)
    subject_alternative_name_list = optional(list(string), [])
  }))
}

variable "domain_enable_transparency_logging_default" {
  type    = bool
  default = true
}

variable "domain_dns_from_zone_key_default" {
  type    = string
  default = null
}

variable "domain_key_algorithm_default" {
  type        = string
  default     = "RSA_2048"
  description = "See https://docs.aws.amazon.com/acm/latest/userguide/acm-certificate.html#algorithms"
}

variable "dns_data" {
  type = object({
    domain_to_dns_zone_map = map(object({
      dns_zone_id = string
    }))
  })
}

{{ std.map() }}
