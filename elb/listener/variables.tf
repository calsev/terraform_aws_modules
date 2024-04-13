variable "dns_data" {
  type = object({
    domain_to_dns_zone_map = map(object({
      dns_zone_id = string
    }))
    region_domain_cert_map = map(map(object({
      certificate_arn = string
    })))
  })
}

variable "elb_data_map" {
  type = map(object({
    elb_arn         = string
    elb_dns_name    = string
    elb_dns_zone_id = string
    protocol_to_listener_map = map(object({
      elb_listener_arn = string
    }))
  }))
}

variable "elb_target_data_map" {
  type = map(object({
    target_group_arn = string
  }))
  default     = null
  description = "Must be provided if any action is a forward"
}

variable "listener_map" {
  type = map(object({
    acm_certificate_fqdn = optional(string)
    action_map = optional(map(object({
      action_fixed_response_content_type         = optional(string)
      action_fixed_response_message_body         = optional(string)
      action_fixed_response_status_code          = optional(number)
      action_forward_stickiness_duration_seconds = optional(number)
      action_forward_stickiness_enabled          = optional(bool)
      action_forward_target_group_map = optional(map(object({
        target_group_weight = optional(number)
      })))
      action_order                                = optional(number)
      action_redirect_host                        = optional(string)
      action_redirect_path                        = optional(string)
      action_redirect_port                        = optional(number)
      action_redirect_protocol                    = optional(string)
      action_redirect_query                       = optional(string)
      action_redirect_status_code                 = optional(string)
      action_type                                 = optional(string)
      auth_authentication_request_extra_param_map = optional(map(string))
      auth_cognito_user_pool_arn                  = optional(string)
      auth_cognito_user_pool_client_app_id        = optional(string)
      auth_cognito_user_pool_fqdn                 = optional(string)
      auth_oidc_authorization_endpoint            = optional(string)
      auth_oidc_client_id                         = optional(string)
      auth_oidc_client_secret                     = optional(string)
      auth_oidc_issuer                            = optional(string)
      auth_oidc_token_endpoint                    = optional(string)
      auth_oidc_user_info_endpoint                = optional(string)
      auth_on_unauthenticated_request             = optional(string)
      auth_scope_list                             = optional(list(string))
      auth_session_cookie_name                    = optional(string)
      auth_session_timeout_seconds                = optional(number)
    })))
    alpn_policy                                            = optional(string)
    elb_key                                                = optional(string)
    dns_from_zone_key                                      = optional(string)
    listen_port                                            = optional(number)
    listen_protocol                                        = optional(string)
    listen_ssl_policy                                      = optional(string)
    mutual_authentication_ignore_client_certificate_expiry = optional(bool)
    mutual_authentication_mode                             = optional(string)
    mutual_authentication_trust_store_arn                  = optional(string)
    name_include_app_fields                                = optional(bool)
    name_infix                                             = optional(bool)
    # If condition map and listener key are both be provided -> is listener rule
    # If neither -> is listener
    rule_condition_map = optional(map(object({
      host_header_pattern_list = optional(list(string))
      http_header_map = optional(map(object({
        pattern_list = list(string)
      })))
      http_request_method_list = optional(list(string))
      path_pattern_list        = optional(list(string))
      query_string_map = optional(map(object({
        key_pattern   = optional(string)
        value_pattern = string
      })))
      source_ip_list = optional(list(string))
    })))
    rule_listener_key = optional(string)
    rule_priority     = optional(number)
  }))
}

variable "listener_acm_certificate_fqdn_default" {
  type        = string
  default     = null
  description = "Must be provided if a listener uses HTTPS. Ignored for other protocols."
}

variable "listener_action_map_default" {
  type = map(object({
    action_fixed_response_content_type         = optional(string)
    action_fixed_response_message_body         = optional(string)
    action_fixed_response_status_code          = optional(number)
    action_forward_stickiness_duration_seconds = optional(number)
    action_forward_stickiness_enabled          = optional(bool)
    action_forward_target_group_map = optional(map(object({
      target_group_weight = optional(number)
    })))
    action_order                                = optional(number)
    action_redirect_host                        = optional(string)
    action_redirect_path                        = optional(string)
    action_redirect_port                        = optional(number)
    action_redirect_protocol                    = optional(string)
    action_redirect_query                       = optional(string)
    action_redirect_status_code                 = optional(string)
    action_type                                 = optional(string)
    auth_authentication_request_extra_param_map = optional(map(string))
    auth_cognito_user_pool_arn                  = optional(string)
    auth_cognito_user_pool_client_app_id        = optional(string)
    auth_cognito_user_pool_fqdn                 = optional(string)
    auth_oidc_authorization_endpoint            = optional(string)
    auth_oidc_client_id                         = optional(string)
    auth_oidc_client_secret                     = optional(string)
    auth_oidc_issuer                            = optional(string)
    auth_oidc_token_endpoint                    = optional(string)
    auth_oidc_user_info_endpoint                = optional(string)
    auth_on_unauthenticated_request             = optional(string)
    auth_scope_list                             = optional(list(string))
    auth_session_cookie_name                    = optional(string)
    auth_session_timeout_seconds                = optional(number)
  }))
  default = {}
}

variable "listener_action_fixed_response_content_type_default" {
  type    = string
  default = "application/json"
  validation {
    condition     = contains(["application/javascript", "application/json", "text/css", "text/html", "text/plain"], var.listener_action_fixed_response_content_type_default)
    error_message = "Invalid action_fixed_response_content_type"
  }
}

variable "listener_action_fixed_response_message_body_default" {
  type    = string
  default = null
}

variable "listener_action_fixed_response_status_code_default" {
  type    = number
  default = 200
  validation {
    condition     = var.listener_action_fixed_response_status_code_default >= 200 && var.listener_action_fixed_response_status_code_default <= 599
    error_message = "Invalid status code"
  }
}

variable "listener_action_forward_stickiness_duration_seconds_default" {
  type    = number
  default = 60
  validation {
    condition     = var.listener_action_forward_stickiness_duration_seconds_default >= 1 && var.listener_action_forward_stickiness_duration_seconds_default <= 60 * 60 * 24 * 7
    error_message = "Invalid stickiness duration"
  }
}

variable "listener_action_forward_stickiness_enabled_default" {
  type    = bool
  default = false
}

variable "listener_action_forward_target_group_map_default" {
  type = map(object({
    target_group_weight = optional(number)
  }))
  default = {}
}

variable "listener_action_forward_target_group_weight_default" {
  type    = number
  default = null # Defaults to 100/length(target_group_map)
}

variable "listener_action_order_default" {
  type    = number
  default = 10000
  validation {
    condition     = var.listener_action_order_default >= 1 && var.listener_action_order_default <= 50000
    error_message = "Invalid action order"
  }
}

variable "listener_action_redirect_host_default" {
  type    = string
  default = "#{host}"
}

variable "listener_action_redirect_path_default" {
  type    = string
  default = "/#{path}"
}

variable "listener_action_redirect_port_default" {
  type        = number
  default     = null
  description = "Defaults to #{port}"
}

variable "listener_action_redirect_protocol_default" {
  type    = string
  default = "#{protocol}"
  validation {
    condition     = contains(["HTTP", "HTTPS", "#{protocol}"], var.listener_action_redirect_protocol_default)
    error_message = "Invalid action_redirect_protocol"
  }
}

variable "listener_action_redirect_query_default" {
  type    = string
  default = "#{query}"
}

variable "listener_action_redirect_status_code_default" {
  type    = string
  default = "HTTP_301"
  validation {
    condition     = contains(["HTTP_301", "HTTP_302"], var.listener_action_redirect_status_code_default)
    error_message = "Invalid action_redirect_status_code"
  }
}

variable "listener_action_type_default" {
  type    = string
  default = null
  validation {
    condition     = var.listener_action_type_default == null ? true : contains(["authenticate-cognito", "authenticate-oidc", "fixed-response", "forward", "redirect"], var.listener_action_type_default)
    error_message = "Invalid action_type"
  }
}

variable "listener_alpn_policy_default" {
  type        = string
  default     = "HTTP2Preferred"
  description = "Ignored unless protocol is TLS"
  validation {
    condition     = contains(["HTTP1Only", "HTTP2Only", "HTTP2Optional", "HTTP2Preferred"], var.listener_alpn_policy_default)
    error_message = "Invalid alpn policy"
  }
}

variable "listener_auth_authentication_request_extra_param_map_default" {
  type        = map(string)
  default     = {}
  description = "Ignored unless action_type is authenticate"
}

variable "listener_auth_cognito_user_pool_arn_default" {
  type        = string
  default     = null
  description = "Ignored unless action_type is authenticate-cognito"
}

variable "listener_auth_cognito_user_pool_client_app_id_default" {
  type        = string
  default     = null
  description = "Ignored unless action_type is authenticate-cognito"
}

variable "listener_auth_cognito_user_pool_fqdn_default" {
  type        = string
  default     = null
  description = "Ignored unless action_type is authenticate-cognito"
}

variable "listener_auth_oidc_authorization_endpoint_default" {
  type        = string
  default     = null
  description = "Ignored unless action_type is authenticate-oidc"
}

variable "listener_auth_oidc_client_id_default" {
  type        = string
  default     = null
  description = "Ignored unless action_type is authenticate-oidc"
}

variable "listener_auth_oidc_client_secret_default" {
  type        = string
  default     = null
  description = "Ignored unless action_type is authenticate-oidc"
}

variable "listener_auth_oidc_issuer_default" {
  type        = string
  default     = null
  description = "Ignored unless action_type is authenticate-oidc"
}

variable "listener_auth_oidc_token_endpoint_default" {
  type        = string
  default     = null
  description = "Ignored unless action_type is authenticate-oidc"
}

variable "listener_auth_oidc_user_info_endpoint_default" {
  type        = string
  default     = null
  description = "Ignored unless action_type is authenticate-oidc"
}

variable "listener_auth_on_unauthenticated_request_default" {
  type        = string
  default     = null # TODO: ?
  description = "Ignored unless action_type is authenticate"
  validation {
    condition     = var.listener_auth_on_unauthenticated_request_default == null ? true : contains(["allow", "authenticate", "deny"], var.listener_auth_on_unauthenticated_request_default)
    error_message = "Invalid auth_on_unauthenticated_request"
  }
}

variable "listener_auth_scope_list_default" {
  type        = list(string)
  default     = ["email", "openid"]
  description = "Ignored unless action_type is authenticate"
}

variable "listener_auth_session_cookie_name_default" {
  type        = string
  default     = null
  description = "Ignored unless action_type is authenticate"
}

variable "listener_auth_session_timeout_seconds_default" {
  type        = number
  default     = null
  description = "Ignored unless action_type is authenticate"
}

variable "listener_dns_from_zone_key_default" {
  type    = string
  default = null
}

variable "listener_elb_key_default" {
  type    = string
  default = null
}

variable "listener_listen_port_default" {
  type    = number
  default = 443
}

variable "listener_listen_protocol_default" {
  type    = string
  default = "HTTPS"
  validation {
    condition = contains([
      "HTTP", "HTTPS",               # ALB
      "TCP", "TCP_UDP", "TLS", "UDP" # NLB
    ], var.listener_listen_protocol_default)
    error_message = "Invalid protocol"
  }
}

variable "listener_listen_ssl_policy_default" {
  type        = string
  default     = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  description = "Ignored unless protocol is HTTPS. See https://docs.aws.amazon.com/elasticloadbalancing/latest/application/create-https-listener.html."
}

variable "listener_mutual_authentication_ignore_client_certificate_expiry_default" {
  type    = bool
  default = false
}

variable "listener_mutual_authentication_mode_default" {
  type    = string
  default = null
  validation {
    condition     = var.listener_mutual_authentication_mode_default == null ? true : contains(["off", "passthrough", "verify"], var.listener_mutual_authentication_mode_default)
    error_message = "Invalid mutual_authentication_mode"
  }
}

variable "listener_mutual_authentication_trust_store_arn_default" {
  type    = string
  default = null
}

variable "listener_name_include_app_fields_default" {
  type    = bool
  default = true
}

variable "listener_name_infix_default" {
  type    = bool
  default = true
}

variable "rule_condition_map_default" {
  type = map(object({
    host_header_pattern_list = optional(list(string))
    http_header_map = optional(map(object({
      pattern_list = list(string)
    })))
    http_request_method_list = optional(list(string))
    path_pattern_list        = optional(list(string))
    query_string_map = optional(map(object({
      key_pattern   = optional(string)
      value_pattern = string
    })))
    source_ip_list = optional(list(string))
  }))
  default = {}
}

variable "rule_host_header_pattern_list_default" {
  type    = list(string)
  default = []
}

variable "rule_http_header_map_default" {
  type = map(object({
    pattern_list = list(string)
  }))
  default     = {}
  description = "A map of header name to value matchers"
}

variable "rule_http_request_method_list_default" {
  type    = list(string)
  default = []
}

variable "rule_path_pattern_list_default" {
  type    = list(string)
  default = []
}

variable "rule_query_string_map_default" {
  type = map(object({
    key_pattern   = optional(string)
    value_pattern = string
  }))
  default = {}
}

variable "rule_source_ip_list_default" {
  type    = list(string)
  default = []
}

variable "rule_listener_key_default" {
  type        = string
  default     = null
  description = "Defaults to protocol. Has no effect if no condition is set."
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
