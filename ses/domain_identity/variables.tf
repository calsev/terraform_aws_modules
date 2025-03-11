variable "config_data_map" {
  type = map(object({
    configuration_set_name = string
  }))
  default     = null
  description = "Must be provided if any domain uses a default config"
}

variable "dns_data" {
  type = object({
    domain_to_dns_zone_map = map(object({
      dns_zone_id = string
    }))
  })
}

variable "domain_map" {
  type = map(object({
    configuration_set_key       = optional(string)
    dkim_signing_key_length     = optional(string)
    dmarc_record_string         = string # This should be something like "v=DMARC1; p=none; rua=mailto:dmarc@domain.com; ruf=mailto:dmarc@domain.com; sp=none; aspf=s; adkim=s; fo=1;"
    dns_from_zone_key           = optional(string)
    email_forwarding_enabled    = optional(bool)
    fallback_to_ses_send_domain = optional(bool)
    mail_from_subdomain         = optional(string)
  }))
}

variable "domain_configuration_set_key_default" {
  type    = string
  default = null
}

variable "domain_dkim_signing_key_length_default" {
  type    = string
  default = "RSA_2048_BIT"
  validation {
    condition     = contains(["RSA_1024_BIT", "RSA_2048_BIT"], var.domain_dkim_signing_key_length_default)
    error_message = "Invalid key length"
  }
}

variable "domain_dns_from_zone_key_default" {
  type    = string
  default = null
}

variable "domain_email_forwarding_enabled_default" {
  type    = bool
  default = true
}

variable "domain_fallback_to_ses_send_domain_default" {
  type    = bool
  default = true
}

variable "domain_mail_from_subdomain_default" {
  type    = string
  default = "mail"
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
