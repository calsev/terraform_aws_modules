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
    acm_certificate_key                                          = optional(string) # Will be injected into HTTPS listener
    desync_mitigation_mode                                       = optional(string)
    dns_from_zone_key                                            = optional(string)
    dns_record_client_routing_policy                             = optional(string)
    drop_invalid_header_fields                                   = optional(bool)
    enable_cross_zone_load_balancing                             = optional(bool)
    enable_deletion_protection                                   = optional(bool)
    enable_dualstack_networking                                  = optional(bool)
    enable_http2                                                 = optional(bool)
    enable_tls_version_and_cipher_suite_headers                  = optional(bool)
    enable_xff_client_port                                       = optional(bool)
    enable_waf_fail_open                                         = optional(bool)
    enforce_security_group_inbound_rules_on_private_link_traffic = optional(bool)
    idle_connection_timeout_seconds                              = optional(string)
    is_internal                                                  = optional(bool)
    load_balancer_type                                           = optional(string)
    log_access_bucket                                            = optional(string)
    log_access_enabled                                           = optional(bool)
    log_connection_bucket                                        = optional(string)
    log_connection_enabled                                       = optional(bool)
    log_db_bucket                                                = optional(string)
    log_db_enabled                                               = optional(bool)
    name_include_app_fields                                      = optional(bool)
    name_infix                                                   = optional(bool)
    preserve_host_header                                         = optional(bool)
    port_to_protocol_to_listener_map = optional(map(map(object({
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

variable "elb_desync_mitigation_mode_default" {
  type    = string
  default = "defensive"
  validation {
    condition     = contains(["defensive", "monitor", "strictest"], var.elb_desync_mitigation_mode_default)
    error_message = "Invalid mitigation mode"
  }
}

variable "elb_dns_record_client_routing_policy_default" {
  type        = string
  default     = "partial_availability_zone_affinity"
  description = "Ignored except for NLB"
  validation {
    condition     = contains(["any_availability_zone", "availability_zone_affinity", "partial_availability_zone_affinity"], var.elb_dns_record_client_routing_policy_default)
    error_message = "Invalid dns routing policy"
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

variable "elb_enable_cross_zone_load_balancing_default" {
  type        = bool
  default     = true
  description = "value"
}

variable "elb_enable_deletion_protection_default" {
  type    = bool
  default = false
}

variable "elb_enable_dualstack_networking_default" {
  type        = bool
  default     = null
  description = "Defaults to true for ALB, false for NLB. Dualstack does not support UDP listeners."
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

variable "elb_load_balancer_type_default" {
  type    = string
  default = "application"
  validation {
    condition     = contains(["application", "gateway", "network"], var.elb_load_balancer_type_default)
    error_message = "Invalid load balancer type"
  }
}

variable "elb_log_access_bucket_default" {
  type    = string
  default = null
}

variable "elb_log_access_enabled_default" {
  type        = bool
  default     = null
  description = "Ignored unless a bucket is specified. Defaults to true for ALB and false for NLB. NLB requires a policy for both the bucket and the customer-managed kms key if encrypted. See https://docs.aws.amazon.com/elasticloadbalancing/latest/network/load-balancer-access-logs.html#access-logging-bucket-requirements"
}

variable "elb_log_connection_bucket_default" {
  type        = string
  default     = null
  description = "Defaults to access log bucket"
}

variable "elb_log_connection_enabled_default" {
  type        = bool
  default     = true
  description = "Ignored unless a bucket is specified"
}

variable "elb_log_db_bucket_default" {
  type        = string
  default     = null
  description = "Defaults to access log bucket"
}

variable "elb_log_db_enabled_default" {
  type        = bool
  default     = true
  description = "Ignored unless a bucket is specified"
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

variable "elb_type_to_port_to_protocol_to_listener_map_default" {
  type = map(map(map(object({
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
  default = {
    application = {
      80 = {
        HTTP = {
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
      443 = {
        HTTPS = {
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
      8443 = {
        HTTPS = { # This is the test port for blue-green deployments
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
    network = {
    }
  }
  description = "These are standard listeners indexed by protocol and port. NLBs do not understand hostname or path, so typically do not have multiple listeners per port."
}

variable "elb_xff_header_processing_mode_default" {
  type    = string
  default = "append"
  validation {
    condition     = contains(["append", "preserve", "remove"], var.elb_xff_header_processing_mode_default)
    error_message = "Invalid XFF header processing mode"
  }
}

variable "elb_enforce_security_group_inbound_rules_on_private_link_traffic_default" {
  type        = bool
  default     = true
  description = "Ignored except for network load balancers"
}

variable "std_map" {
  type = object({
    aws_account_id       = string
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
