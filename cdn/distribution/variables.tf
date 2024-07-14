variable "bucket_log_target_bucket_name_default" {
  type    = string
  default = null
}

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
      waf_acl_arn = string
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
    cache_viewer_protocol_policy      = optional(string)
    default_root_object               = optional(string)
    dns_alias_enabled                 = optional(bool)
    dns_alias_san_list                = optional(list(string))
    dns_from_zone_key                 = optional(string)
    enabled                           = optional(bool)
    http_version_max_supported        = optional(string)
    ipv6_enabled                      = optional(bool)
    logging_bucket_key                = optional(string)
    logging_include_cookies           = optional(bool)
    logging_object_prefix             = optional(string)
    name_include_app_fields           = optional(bool)
    name_infix                        = optional(bool)
    origin_allow_public               = optional(bool)
    origin_connection_attempts        = optional(number)
    origin_connection_timeout_seconds = optional(number)
    origin_dns_enabled                = optional(bool)
    origin_fqdn                       = string
    origin_path                       = optional(string)
    origin_request_policy_key         = optional(string)
    price_class                       = optional(string)
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
    response_security_header_content_policy_origin_map    = optional(map(list(string)))
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
    retain_on_delete                                      = optional(bool)
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
    smooth_streaming_enabled                    = optional(bool)
    trusted_key_group_key_list                  = optional(list(string))
    viewer_certificate_minimum_protocol_version = optional(string)
    viewer_certificate_ssl_support_method       = optional(string)
    wait_for_deployment                         = optional(bool)
    web_acl_key                                 = optional(string)
  }))
}

variable "domain_cache_policy_key_default" {
  type    = string
  default = "max_cache"
}

variable "domain_cache_viewer_protocol_policy_default" {
  type    = string
  default = "redirect-to-https"
  validation {
    condition     = contains(["allow-all", "https-only", "redirect-to-https"], var.domain_cache_viewer_protocol_policy_default)
    error_message = "Invalid viewer protocol policy"
  }
}

variable "domain_default_root_object_default" {
  type    = string
  default = "index.html"
}

variable "domain_dns_alias_enabled_default" {
  type    = bool
  default = true
}

variable "domain_dns_alias_san_list_default" {
  type        = list(string)
  default     = []
  description = "Subject alternate names on the DNS certficate to add as aliases. Ignored if DNS alias not enabled."
}

variable "domain_dns_from_zone_key_default" {
  type    = string
  default = null
}

variable "domain_enabled_default" {
  type    = bool
  default = true
}

variable "domain_http_version_max_supported_default" {
  type    = string
  default = "http2and3"
  validation {
    condition     = contains(["http1.1", "http2", "http2and3", "http3"], var.domain_http_version_max_supported_default)
    error_message = "Invalid HTTP version"
  }
}

variable "domain_ipv6_enabled_default" {
  type    = bool
  default = true
}

variable "domain_logging_bucket_key_default" {
  type    = string
  default = null
}

variable "domain_logging_include_cookies_default" {
  type    = bool
  default = false
}

variable "domain_logging_object_prefix_default" {
  type    = string
  default = ""
}

variable "domain_origin_allow_public_default" {
  type    = bool
  default = false
}

variable "domain_origin_connection_attempts_default" {
  type    = number
  default = 3
}

variable "domain_origin_connection_timeout_seconds_default" {
  type    = number
  default = 10
}

variable "domain_origin_dns_enabled_default" {
  type    = bool
  default = true
}

variable "domain_origin_path_default" {
  type    = string
  default = ""
}

variable "domain_origin_request_policy_key_default" {
  type    = string
  default = "max_cache"
}

variable "domain_price_class_default" {
  type    = string
  default = "PriceClass_All"
  validation {
    condition     = contains(["PriceClass_100", "PriceClass_200", "PriceClass_All"], var.domain_price_class_default)
    error_message = "Invalid price class"
  }
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
  description = "This is list concatenated to the https://aliases of the CDN"
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

variable "domain_response_security_header_content_policy_origin_map_default" {
  type = map(list(string))
  default = {
    default-src = []
  }
  description = "'self' and https://dns_from_zone_key will be prepended to all lists"
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

variable "domain_retain_on_delete_default" {
  type    = bool
  default = false
}

variable "domain_smooth_streaming_enabled_default" {
  type    = bool
  default = false
}

variable "domain_viewer_certificate_minimum_protocol_version_default" {
  type        = string
  default     = "TLSv1.2_2021"
  description = "Ignored unless DNS alias is enabled"
}

variable "domain_viewer_certificate_ssl_support_method_default" {
  type        = string
  default     = "sni-only"
  description = "Ignored unless DNS alias is enabled"
  validation {
    condition     = contains(["sni-only", "static-ip", "vip"], var.domain_viewer_certificate_ssl_support_method_default)
    error_message = "Invalid SSL support method"
  }
}

variable "domain_trusted_key_group_key_list_default" {
  type    = list(string)
  default = []
}

variable "domain_wait_for_deployment_default" {
  type    = bool
  default = true
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

variable "name_include_app_fields_default" {
  type        = bool
  default     = false
  description = "If true, the Terraform project context will be included in the name"
}

variable "name_infix_default" {
  type    = bool
  default = true
}

variable "s3_data_map" {
  type = map(object({
    name_effective = string
  }))
  default     = null
  description = "Must be provided if any CDN specifies a log bucket"
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
