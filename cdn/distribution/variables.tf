variable "cdn_global_data" {
  type = object({
    cache_policy_map = map(object({
      policy_id = string
    }))
    domain_cert_map = map(object({
      certificate_arn = string
    }))
    origin_request_policy_map = map(object({
      policy_id = string
    }))
    web_acl_map = map(object({
      waf_arn = string
    }))
  })
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
    cache_policy_key                  = optional(string)
    dns_from_zone_key                 = optional(string)
    name_infix                        = optional(bool)
    origin_allow_public               = optional(bool)
    origin_dns_enabled                = optional(bool)
    origin_fqdn                       = string
    origin_path                       = optional(string)
    origin_request_policy_key         = optional(string)
    response_cors_allow_credentials   = optional(bool)
    response_cors_allowed_header_list = optional(list(string))
    response_cors_allowed_method_list = optional(list(string))
    response_cors_allowed_origin_list = optional(list(string))
    response_cors_expose_header_list  = optional(list(string))
    response_cors_max_age_seconds     = optional(number)
    response_cors_origin_override     = optional(bool)
    response_custom_header_map = optional(map(object({
      override = optional(bool)
      value    = string
    })))
    response_remove_header_list                           = optional(list(string))
    response_security_header_content_policy               = optional(string)
    response_security_header_content_override             = optional(bool)
    response_security_header_content_type_override        = optional(bool)
    response_security_header_frame_option                 = optional(string)
    response_security_header_frame_override               = optional(bool)
    response_security_header_referrer_override            = optional(bool)
    response_security_header_referrer_policy              = optional(string)
    response_security_header_transport_max_age_seconds    = optional(number)
    response_security_header_transport_include_subdomains = optional(bool)
    response_security_header_transport_override           = optional(bool)
    response_security_header_transport_preload            = optional(bool)
    response_server_timing_enabled                        = optional(bool)
    response_server_timing_sampling_rate                  = optional(number)
    sid_map = optional(map(object({
      access = string
      condition_map = optional(map(object({
        test       = string
        value_list = list(string)
        variable   = string
      })))
      identifier_list = optional(list(string))
      identifier_type = optional(string)
      object_key_list = optional(list(string))
    })))
    trusted_key_group_key_list = optional(list(string))
    web_acl_key                = optional(string)
  }))
}

variable "domain_cache_policy_key_default" {
  type    = string
  default = "max_cache"
}

variable "domain_dns_from_zone_key_default" {
  type    = string
  default = null
}

variable "domain_name_infix_default" {
  type    = bool
  default = false
}

variable "domain_origin_allow_public_default" {
  type    = bool
  default = false
}

variable "domain_origin_dns_enabled_default" {
  type    = bool
  default = false
}

variable "domain_origin_path_default" {
  type    = string
  default = ""
}

variable "domain_origin_request_policy_key_default" {
  type    = string
  default = "max_cache"
}

variable "domain_response_cors_allow_credentials_default" {
  type    = bool
  default = false
}

variable "domain_response_cors_allowed_header_list_default" {
  type    = list(string)
  default = ["*"]
}

variable "domain_response_cors_allowed_method_list_default" {
  type = list(string)
  default = [
    "GET",
    "HEAD",
    "OPTIONS",
  ]
}

variable "domain_response_cors_allowed_origin_list_default" {
  type        = list(string)
  default     = []
  description = "This is list concatenated to the https://domain alias of the CDN"
}

variable "domain_response_cors_expose_header_list_default" {
  type    = list(string)
  default = [] # TODO: *?
}

variable "domain_response_cors_max_age_seconds_default" {
  type        = number
  default     = 60
  description = "https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Access-Control-Max-Age"
}

variable "domain_response_cors_origin_override_default" {
  type    = bool
  default = true
}

variable "domain_response_custom_header_map_default" {
  type = map(object({
    override = optional(bool)
    value    = string
  }))
  default = {
  }
  description = "Key is the header key"
}

variable "domain_response_custom_header_override_default" {
  type    = bool
  default = true
}

variable "domain_response_remove_header_list_default" {
  type    = list(string)
  default = []
}

variable "domain_response_security_header_content_policy_default" {
  type    = string
  default = "default-src 'self'"
}

variable "domain_response_security_header_content_override_default" {
  type    = bool
  default = true
}

variable "domain_response_security_header_content_type_override_default" {
  type    = bool
  default = true
}

variable "domain_response_security_header_frame_option_default" {
  type    = string
  default = "DENY"
}

variable "domain_response_security_header_frame_override_default" {
  type    = bool
  default = true
}

variable "domain_response_security_header_referrer_override_default" {
  type    = bool
  default = true
}

variable "domain_response_security_header_referrer_policy_default" {
  type    = string
  default = "same-origin"
}

variable "domain_response_security_header_transport_max_age_seconds_default" {
  type        = number
  default     = 60 * 60 * 24 * 365
  description = "Must be at least one year for preloading, see https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Strict-Transport-Security"
}

variable "domain_response_security_header_transport_include_subdomains_default" {
  type        = bool
  default     = true
  description = "Must be true for preloading"
}

variable "domain_response_security_header_transport_override_default" {
  type    = bool
  default = true
}

variable "domain_response_security_header_transport_preload_default" {
  type    = bool
  default = true
}

variable "domain_response_server_timing_enabled_default" {
  type    = bool
  default = false
}

variable "domain_response_server_timing_sampling_rate_default" {
  type    = number
  default = 0
}

variable "domain_trusted_key_group_key_list_default" {
  type    = list(string)
  default = []
}

variable "domain_web_acl_key_default" {
  type    = string
  default = "basic_rate_limit"
}

variable "key_group_data_map" {
  type = map(object({
    group_id = string
  }))
  default     = {}
  description = "Must be provided if any distribution has a trusted key group"
}

variable "std_map" {
  type = object({
    access_title_map               = map(string)
    aws_account_id                 = string
    aws_region_name                = string
    iam_partition                  = string
    name_replace_regex             = string
    resource_name_prefix           = string
    resource_name_suffix           = string
    service_resource_access_action = map(map(map(list(string))))
    tags                           = map(string)
  })
}
