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

variable "elb_map" {
  type = map(object({
    access_log_bucket                           = optional(string)
    access_log_enabled                          = optional(bool)
    acm_certificate_key                         = optional(string) # Will be injected into HTTPS listener
    connection_log_bucket                       = optional(string)
    connection_log_enabled                      = optional(bool)
    desync_mitigation_mode                      = optional(string)
    dns_from_zone_key                           = optional(string)
    drop_invalid_header_fields                  = optional(bool)
    enable_deletion_protection                  = optional(bool)
    enable_dualstack_networking                 = optional(bool)
    enable_http2                                = optional(bool)
    enable_tls_version_and_cipher_suite_headers = optional(bool)
    enable_xff_client_port                      = optional(bool)
    enable_waf_fail_open                        = optional(bool)
    idle_connection_timeout_seconds             = optional(string)
    is_internal                                 = optional(bool)
    name_include_app_fields                     = optional(bool)
    name_infix                                  = optional(bool)
    preserve_host_header                        = optional(bool)
    protocol_to_port_to_listener_map = optional(map(map(object({
      action_map = map(object({
        action_fixed_response_content_type = optional(string)
        action_fixed_response_message_body = optional(string)
        action_fixed_response_status_code  = optional(number)
        action_order                       = optional(number)
        action_redirect_host               = optional(string)
        action_redirect_path               = optional(string)
        action_redirect_port               = optional(number)
        action_redirect_protocol           = optional(string)
        action_redirect_query              = optional(string)
        action_redirect_status_code        = optional(string)
        action_type                        = optional(string)
      }))
      listen_ssl_policy = optional(string)
    }))))
    vpc_az_key_list             = optional(list(string))
    vpc_key                     = optional(string)
    vpc_security_group_key_list = optional(list(string))
    vpc_segment_key             = optional(string)
    xff_header_processing_mode  = optional(string)
  }))
}

variable "elb_access_log_bucket_default" {
  type    = string
  default = null
}

variable "elb_access_log_enabled_default" {
  type        = bool
  default     = true
  description = "Ignored unless a bucket is specified"
}

variable "elb_connection_log_bucket_default" {
  type        = string
  default     = null
  description = "Defaults to access log bucket"
}

variable "elb_connection_log_enabled_default" {
  type        = bool
  default     = true
  description = "Ignored unless a bucket is specified"
}

variable "elb_desync_mitigation_mode_default" {
  type    = string
  default = "defensive"
  validation {
    condition     = contains(["defensive", "monitor", "strictest"], var.elb_desync_mitigation_mode_default)
    error_message = "Invalid mitigation mode"
  }
}

variable "elb_dns_from_zone_key_default" {
  type    = string
  default = null
}

variable "elb_drop_invalid_header_fields_default" {
  type    = bool
  default = false
}

variable "elb_enable_deletion_protection_default" {
  type    = bool
  default = false
}

variable "elb_enable_dualstack_networking_default" {
  type    = bool
  default = true
}

variable "elb_enable_http2_default" {
  type    = bool
  default = true
}

variable "elb_enable_tls_version_and_cipher_suite_headers_default" {
  type    = bool
  default = false
}

variable "elb_enable_xff_client_port_default" {
  type    = bool
  default = false
}

variable "elb_enable_waf_fail_open_default" {
  type    = bool
  default = false
}

variable "elb_idle_connection_timeout_seconds_default" {
  type    = number
  default = 60
}

variable "elb_is_internal_default" {
  type    = bool
  default = false
}

variable "elb_name_include_app_fields_default" {
  type        = bool
  default     = false
  description = "If true, the Terraform project context will be included in the name"
}

variable "elb_name_infix_default" {
  type    = bool
  default = true
}

variable "elb_preserve_host_header_default" {
  type    = bool
  default = false
}

variable "elb_protocol_to_port_to_listener_map_default" {
  type = map(map(object({
    action_map = map(object({
      action_fixed_response_content_type = optional(string)
      action_fixed_response_message_body = optional(string)
      action_fixed_response_status_code  = optional(number)
      action_order                       = optional(number)
      action_redirect_host               = optional(string)
      action_redirect_path               = optional(string)
      action_redirect_port               = optional(number)
      action_redirect_protocol           = optional(string)
      action_redirect_query              = optional(string)
      action_redirect_status_code        = optional(string)
      action_type                        = optional(string)
    }))
    listen_ssl_policy = optional(string)
  })))
  default = {
    HTTP = {
      80 = {
        action_map = {
          default_redirect = {
            action_fixed_response_content_type = null
            action_fixed_response_message_body = null
            action_fixed_response_status_code  = null
            action_order                       = 50000
            action_redirect_host               = null
            action_redirect_path               = null
            action_redirect_port               = 443
            action_redirect_protocol           = "HTTPS"
            action_redirect_query              = null
            action_redirect_status_code        = null
            action_type                        = "redirect"
          }
        }
        listen_ssl_policy = null
      }
    }
    HTTPS = {
      443 = {
        action_map = {
          default_not_found = {
            action_fixed_response_content_type = null
            action_fixed_response_message_body = "{status:\"Not Found\"}"
            action_fixed_response_status_code  = 404
            action_order                       = 50000
            action_redirect_host               = null
            action_redirect_path               = null
            action_redirect_port               = null
            action_redirect_protocol           = null
            action_redirect_query              = null
            action_redirect_status_code        = null
            action_type                        = "fixed-response"
          }
        }
        listen_ssl_policy = "ELBSecurityPolicy-TLS13-1-2-2021-06"
      }
      8443 = { # This is the test port for blue-green deployments
        action_map = {
          default_not_found = {
            action_fixed_response_content_type = null
            action_fixed_response_message_body = "{status:\"Not Found\"}"
            action_fixed_response_status_code  = 404
            action_order                       = 50000
            action_redirect_host               = null
            action_redirect_path               = null
            action_redirect_port               = null
            action_redirect_protocol           = null
            action_redirect_query              = null
            action_redirect_status_code        = null
            action_type                        = "fixed-response"
          }
        }
        listen_ssl_policy = "ELBSecurityPolicy-TLS13-1-2-2021-06"
      }
    }
  }
  description = "These are standard listeners indexed by protocol and port"
}

variable "elb_xff_header_processing_mode_default" {
  type    = string
  default = "append"
  validation {
    condition     = contains(["append", "preserve", "remove"], var.elb_xff_header_processing_mode_default)
    error_message = "Invalid XFF header processing mode"
  }
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

variable "vpc_az_key_list_default" {
  type    = list(string)
  default = ["a", "b"]
}

variable "vpc_data_map" {
  type = map(object({
    security_group_id_map = map(string)
    segment_map = map(object({
      route_public  = bool
      subnet_id_map = map(string)
    }))
    vpc_assign_ipv6_cidr = bool
    vpc_id               = string
  }))
}

variable "vpc_key_default" {
  type    = string
  default = null
}

variable "vpc_security_group_key_list_default" {
  type = list(string)
  default = [
    "internal_http_alt_in",
    "internal_http_in", # For port 80
    "world_all_out",
    "world_http_in",
  ]
}

variable "vpc_segment_key_default" {
  type    = string
  default = "public"
}
