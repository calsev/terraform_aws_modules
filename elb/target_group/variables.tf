# name is limited to 32 characters
variable "name_append_default" {
  type        = string
  default     = ""
  description = "Appended after key"
}

variable "name_include_app_fields_default" {
  type        = bool
  default     = false
  description = "If true, standard project context will be prefixed to the name. Ignored if not name_infix."
}

variable "name_infix_default" {
  type        = bool
  default     = true
  description = "If true, standard project prefix and resource suffix will be added to the name"
}

variable "name_prefix_default" {
  type        = string
  default     = ""
  description = "Prepended before context prefix"
}

variable "name_prepend_default" {
  type        = string
  default     = ""
  description = "Prepended before key"
}

# tflint-ignore: terraform_unused_declarations
variable "name_regex_allow_list" {
  type        = list(string)
  default     = []
  description = "By default, all punctuation is replaced by -"
}

variable "name_suffix_default" {
  type        = string
  default     = ""
  description = "Appended after context suffix"
}

variable "target_map" {
  type = map(object({
    draining_to_unused_delay_seconds                   = optional(number)
    glb_failover_on_deregistration_or_unhealthy        = optional(bool)
    health_check_consecutive_fail_threshold            = optional(number)
    health_check_consecutive_success_threshold         = optional(number)
    health_check_enabled                               = optional(bool)
    health_check_http_path                             = optional(string)
    health_check_interval_seconds                      = optional(number)
    health_check_no_response_timeout_seconds           = optional(number)
    health_check_port                                  = optional(number)
    health_check_protocol                              = optional(string)
    health_check_success_code_list                     = optional(list(number))
    lambda_multi_value_headers_enabled                 = optional(bool)
    load_balancing_algorithm_type                      = optional(string)
    load_balancing_anomaly_mitigation_enabled          = optional(bool)
    load_balancing_cross_zone_mode                     = optional(string)
    name_append                                        = optional(string)
    name_include_app_fields                            = optional(bool)
    name_infix                                         = optional(bool)
    name_prefix                                        = optional(string)
    name_prepend                                       = optional(string)
    name_suffix                                        = optional(string)
    nlb_enable_proxy_protocol_v2                       = optional(bool)
    nlb_preserve_client_ip                             = optional(bool)
    nlb_terminate_connection_on_deregistration_timeout = optional(bool)
    nlb_terminate_connection_on_unhealthy              = optional(bool)
    sticky_cookie_duration_seconds                     = optional(number)
    sticky_cookie_enabled                              = optional(bool)
    sticky_cookie_name                                 = optional(string)
    sticky_type                                        = optional(string)
    target_ip_use_v6                                   = optional(bool)
    target_port                                        = optional(number)
    target_protocol                                    = optional(string)
    target_protocol_http_version                       = optional(string)
    target_type                                        = optional(string)
    target_warm_up_seconds                             = optional(number)
    vpc_key                                            = optional(string)
  }))
}

variable "target_draining_to_unused_delay_seconds_default" {
  type    = number
  default = 300
}

variable "target_glb_failover_on_deregistration_or_unhealthy_default" {
  type    = bool
  default = false
}

variable "target_health_check_consecutive_fail_threshold_default" {
  type    = number
  default = 3
  validation {
    condition     = var.target_health_check_consecutive_fail_threshold_default >= 2 && var.target_health_check_consecutive_fail_threshold_default <= 10
    error_message = "Invalid fail threshold"
  }
}

variable "target_health_check_consecutive_success_threshold_default" {
  type    = number
  default = 3
  validation {
    condition     = var.target_health_check_consecutive_success_threshold_default >= 2 && var.target_health_check_consecutive_success_threshold_default <= 10
    error_message = "Invalid success threshold"
  }
}

variable "target_health_check_enabled_default" {
  type    = bool
  default = true
}

variable "target_health_check_http_path_default" {
  type        = string
  default     = "/health"
  description = "Ignored unless health check protocol is HTTP or HTTPS"
}

variable "target_health_check_interval_seconds_default" {
  type    = string
  default = 30
  validation {
    condition     = var.target_health_check_interval_seconds_default >= 5 && var.target_health_check_interval_seconds_default <= 300
    error_message = "Invalid health check interval"
  }
}

variable "target_health_check_no_response_timeout_seconds_default" {
  type        = number
  default     = 6
  description = "Default is for HTTP"
  validation {
    condition     = var.target_health_check_no_response_timeout_seconds_default >= 2 && var.target_health_check_no_response_timeout_seconds_default <= 120
    error_message = "Invalid health check interval"
  }
}

variable "target_health_check_port_default" {
  type        = number
  default     = null
  description = "defaults to traffic-port"
}

variable "target_health_check_protocol_default" {
  type        = string
  default     = null
  description = "Defaults to HTTP for target_protocol HTTP/HTTPS, all others TCP. Ignored for lambda targets."
  validation {
    condition     = var.target_health_check_protocol_default == null ? true : contains(["TCP", "HTTP", "HTTPS"], var.target_health_check_protocol_default)
    error_message = "Invalid health_check_protocol"
  }
}

variable "target_health_check_success_code_list_default" {
  type        = list(number)
  default     = [200, 201, 202, 203, 204, 205, 206, 207, 208, 226, 300, 301, 302, 303, 304, 307, 308, 401, 402, 403, 404, 405, 410]
  description = "Ingored unless health_check_protocol is HTTP/HTTPS"
}

variable "target_lambda_multi_value_headers_enabled_default" {
  type    = bool
  default = false
}

variable "target_load_balancing_algorithm_type_default" {
  type        = string
  default     = "round_robin"
  description = "Ignored for network load balancers"
  validation {
    condition     = contains(["least_outstanding_requests", "round_robin", "weighted_random"], var.target_load_balancing_algorithm_type_default)
    error_message = "Invalid load_balancing_algorithm_type"
  }
}

variable "target_load_balancing_anomaly_mitigation_enabled_default" {
  type        = bool
  default     = false
  description = "Ignored for network load balancers. Only supported for weighted_random algorithm"
}

variable "target_load_balancing_cross_zone_mode_default" {
  type    = string
  default = "use_load_balancer_configuration"
  validation {
    condition     = contains(["use_load_balancer_configuration", "false", "true"], var.target_load_balancing_cross_zone_mode_default)
    error_message = "Invalid cross-zone mode"
  }
}

variable "target_nlb_enable_proxy_protocol_v2_default" {
  type        = bool
  default     = false
  description = "Make sure target supports protocol headers before enabling this."
}

variable "target_nlb_preserve_client_ip_default" {
  type    = bool
  default = true
}

variable "target_nlb_terminate_connection_on_deregistration_timeout_default" {
  type        = bool
  default     = false
  description = "Ignored for UDP targets"
}

variable "target_nlb_terminate_connection_on_unhealthy_default" {
  type        = bool
  default     = true
  description = "Ignored for UDP targets"
}

variable "target_sticky_cookie_duration_seconds_default" {
  type        = number
  default     = 60 * 60 * 24
  description = "Ignored for Lambda targets"
}

variable "target_sticky_cookie_enabled_default" {
  type        = bool
  default     = false
  description = "Ignored for Lambda targets"
}

variable "target_sticky_cookie_name_default" {
  type        = string
  default     = null
  description = "Ignored for Lambda targets"
}

variable "target_sticky_type_default" {
  type        = string
  default     = null
  description = "Defaults to lb_cookie for target_protocol HTTP/HTTPS, source_ip otherwise. Cookie type is set, but not enabled by default. Ignored for Lambda targets."
  validation {
    condition = var.target_sticky_type_default == null ? true : contains([
      "lb_cookie", "app_cookie",                      # ALB
      "source_ip",                                    # NLB
      "source_ip_dest_ip", "source_ip_dest_ip_proto", # GWLB
    ], var.target_sticky_type_default)
    error_message = "Invalid sticky_type"
  }
}

variable "target_ip_use_v6_default" {
  type    = bool
  default = false
}

variable "target_port_default" {
  type        = number
  default     = 80
  description = "Ignored for lambda targets"
}

variable "target_protocol_default" {
  type        = string
  default     = "HTTP"
  description = "Ignored for lambda targets"
  validation {
    condition     = contains(["GENEVE", "HTTP", "HTTPS", "TCP", "TCP_UDP", "TLS", "UDP"], var.target_protocol_default)
    error_message = "Invalid target protocol"
  }
}

variable "target_protocol_http_version_default" {
  type        = string
  default     = "HTTP1"
  description = "Ingored unless target protocol is HTTP or HTTPS"
  validation {
    condition     = contains(["GRPC", "HTTP1", "HTTP2"], var.target_protocol_http_version_default)
    error_message = "Invalid target protocol version"
  }
}

variable "target_type_default" {
  type        = string
  default     = "ip"
  description = "For awsvpc networking mode ip is required, for bridged networking instance is appropriate."
  validation {
    condition     = contains(["instance", "ip", "lambda", "alb"], var.target_type_default)
    error_message = "Invalid target_type"
  }
}

variable "target_warm_up_seconds_default" {
  type    = number
  default = 0
  validation {
    condition     = var.target_warm_up_seconds_default == 0 || var.target_warm_up_seconds_default >= 30 && var.target_warm_up_seconds_default <= 900
    error_message = "Invalid target_warm_up_seconds"
  }
}

variable "vpc_data_map" {
  type = map(object({
    name_simple           = string
    security_group_id_map = map(string)
    segment_map = map(object({
      route_public  = bool
      subnet_id_map = map(string)
      subnet_map = map(object({
        availability_zone_name = string
      }))
    }))
    vpc_assign_ipv6_cidr = bool
    vpc_cidr_block       = string
    vpc_id               = string
    vpc_ipv6_cidr_block  = string
  }))
}

variable "vpc_key_default" {
  type    = string
  default = null
}

variable "std_map" {
  type = object({
    access_title_map               = map(string)
    aws_account_id                 = string
    aws_region_name                = string
    config_name                    = string
    env                            = string
    iam_partition                  = string
    name_replace_regex             = string
    resource_name_prefix           = string
    resource_name_suffix           = string
    service_resource_access_action = map(map(map(list(string))))
    tags                           = map(string)
  })
}
