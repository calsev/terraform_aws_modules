resource "aws_lb_listener" "this_listener" {
  for_each        = local.create_listener_map
  alpn_policy     = each.value.alpn_policy_effective
  certificate_arn = each.value.acm_certificate_arn
  dynamic "default_action" {
    for_each = each.value.action_map
    content {
      dynamic "authenticate_cognito" {
        for_each = default_action.value.action_type == "authenticate-cognito" ? { this = {} } : {}
        content {
          authentication_request_extra_params = default_action.value.auth_authentication_request_extra_param_map
          on_unauthenticated_request          = default_action.value.auth_on_unauthenticated_request
          scope                               = default_action.value.auth_scope_string
          session_cookie_name                 = default_action.value.auth_session_cookie_name
          session_timeout                     = default_action.value.auth_session_timeout_seconds
          user_pool_arn                       = default_action.value.auth_cognito_user_pool_arn
          user_pool_client_id                 = default_action.value.auth_cognito_client_app_id
          user_pool_domain                    = default_action.value.auth_cognito_user_pool_fqdn
        }
      }
      dynamic "authenticate_oidc" {
        for_each = default_action.value.action_type == "authenticate-oidc" ? { this = {} } : {}
        content {
          authentication_request_extra_params = default_action.value.auth_authentication_request_extra_param_map
          authorization_endpoint              = default_action.value.auth_oidc_authorization_endpoint
          client_id                           = default_action.value.auth_oidc_client_id
          client_secret                       = default_action.value.auth_oidc_client_secret
          issuer                              = default_action.value.auth_oidc_issuer
          on_unauthenticated_request          = default_action.value.auth_on_unauthenticated_request
          scope                               = default_action.value.auth_scope_string
          session_cookie_name                 = default_action.value.auth_session_cookie_name
          session_timeout                     = default_action.value.auth_session_timeout_seconds
          token_endpoint                      = default_action.value.auth_oidc_token_endpoint
          user_info_endpoint                  = default_action.value.auth_oidc_user_info_endpoint
        }
      }
      dynamic "fixed_response" {
        for_each = default_action.value.action_type == "fixed-response" ? { this = {} } : {}
        content {
          content_type = default_action.value.action_fixed_response_content_type
          message_body = default_action.value.action_fixed_response_message_body
          status_code  = default_action.value.action_fixed_response_status_code
        }
      }
      dynamic "forward" {
        for_each = default_action.value.action_type == "forward" ? { this = {} } : {}
        content {
          stickiness {
            duration = default_action.value.action_forward_stickiness_duration_seconds
            enabled  = default_action.value.action_forward_stickiness_enabled
          }
          dynamic "target_group" {
            for_each = default_action.value.action_forward_target_group_map
            content {
              arn    = target_group.value.target_group_arn
              weight = target_group.value.target_group_weight
            }
          }
        }
      }
      order = default_action.value.action_order
      dynamic "redirect" {
        for_each = default_action.value.action_type == "redirect" ? { this = {} } : {}
        content {
          host        = default_action.value.action_redirect_host
          path        = default_action.value.action_redirect_path
          port        = default_action.value.action_redirect_port
          protocol    = default_action.value.action_redirect_protocol
          query       = default_action.value.action_redirect_query
          status_code = default_action.value.action_redirect_status_code
        }
      }
      target_group_arn = null # Conflicts with forward
      type             = default_action.value.action_type
    }
  }
  load_balancer_arn = each.value.elb_arn
  dynamic "mutual_authentication" {
    for_each = each.value.mutual_authentication_mode == null ? {} : { this = {} }
    content {
      ignore_client_certificate_expiry = each.value.mutual_authentication_ignore_client_certificate_expiry
      mode                             = each.value.mutual_authentication_mode
      trust_store_arn                  = each.value.mutual_authentication_trust_store_arn
    }
  }
  port       = each.value.listen_port
  protocol   = each.value.listen_protocol
  ssl_policy = each.value.listen_ssl_policy_effective
  tags       = each.value.tags
}

resource "aws_lb_listener_rule" "this_rule" {
  for_each = local.create_rule_map
  dynamic "action" {
    for_each = each.value.action_map
    content {
      dynamic "authenticate_cognito" {
        for_each = action.value.action_type == "authenticate-cognito" ? { this = {} } : {}
        content {
          authentication_request_extra_params = action.value.auth_authentication_request_extra_param_map
          on_unauthenticated_request          = action.value.auth_on_unauthenticated_request
          scope                               = action.value.auth_scope_string
          session_cookie_name                 = action.value.auth_session_cookie_name
          session_timeout                     = action.value.auth_session_timeout_seconds
          user_pool_arn                       = action.value.auth_cognito_user_pool_arn
          user_pool_client_id                 = action.value.auth_cognito_client_app_id
          user_pool_domain                    = action.value.auth_cognito_user_pool_fqdn
        }
      }
      dynamic "authenticate_oidc" {
        for_each = action.value.action_type == "authenticate-oidc" ? { this = {} } : {}
        content {
          authentication_request_extra_params = action.value.auth_authentication_request_extra_param_map
          authorization_endpoint              = action.value.auth_oidc_authorization_endpoint
          client_id                           = action.value.auth_oidc_client_id
          client_secret                       = action.value.auth_oidc_client_secret
          issuer                              = action.value.auth_oidc_issuer
          on_unauthenticated_request          = action.value.auth_on_unauthenticated_request
          scope                               = action.value.auth_scope_string
          session_cookie_name                 = action.value.auth_session_cookie_name
          session_timeout                     = action.value.auth_session_timeout_seconds
          token_endpoint                      = action.value.auth_oidc_token_endpoint
          user_info_endpoint                  = action.value.auth_oidc_user_info_endpoint
        }
      }
      dynamic "fixed_response" {
        for_each = action.value.action_type == "fixed-response" ? { this = {} } : {}
        content {
          content_type = action.value.action_fixed_response_content_type
          message_body = action.value.action_fixed_response_message_body
          status_code  = action.value.action_fixed_response_status_code
        }
      }
      dynamic "forward" {
        for_each = action.value.action_type == "forward" ? { this = {} } : {}
        content {
          stickiness {
            duration = action.value.action_forward_stickiness_duration_seconds
            enabled  = action.value.action_forward_stickiness_enabled
          }
          dynamic "target_group" {
            for_each = action.value.action_forward_target_group_map
            content {
              arn    = target_group.value.target_group_arn
              weight = target_group.value.target_group_weight
            }
          }
        }
      }
      order = action.value.action_order
      dynamic "redirect" {
        for_each = action.value.action_type == "redirect" ? { this = {} } : {}
        content {
          host        = action.value.action_redirect_host
          path        = action.value.action_redirect_path
          port        = action.value.action_redirect_port
          protocol    = action.value.action_redirect_protocol
          query       = action.value.action_redirect_query
          status_code = action.value.action_redirect_status_code
        }
      }
      target_group_arn = null # Conflicts with forward
      type             = action.value.action_type
    }
  }
  dynamic "condition" {
    for_each = each.value.rule_condition_map
    content {
      dynamic "host_header" {
        for_each = length(condition.value.host_header_pattern_list) != 0 ? { this = {} } : {}
        content {
          values = condition.value.host_header_pattern_list
        }
      }
      dynamic "http_header" {
        for_each = condition.value.http_header_map
        content {
          http_header_name = http_header.key
          values           = http_header.value.pattern_list
        }
      }
      dynamic "http_request_method" {
        for_each = length(condition.value.http_request_method_list) != 0 ? { this = {} } : {}
        content {
          values = condition.value.http_request_method_list
        }
      }
      dynamic "path_pattern" {
        for_each = length(condition.value.path_pattern_list) != 0 ? { this = {} } : {}
        content {
          values = condition.value.path_pattern_list
        }
      }
      dynamic "query_string" {
        for_each = condition.value.query_string_map
        content {
          key   = query_string.key_pattern
          value = query_string.value_pattern
        }
      }
      dynamic "source_ip" {
        for_each = length(condition.value.source_ip_list) != 0 ? { this = {} } : {}
        content {
          values = condition.value.source_ip_list
        }
      }
    }
  }
  lifecycle {
    ignore_changes = [
      action[0].forward[0].target_group, # TODO: Eye roll: https://github.com/hashicorp/terraform/issues/24188
    ]
  }
  listener_arn = each.value.elb_listener_arn
  priority     = each.value.rule_priority
  tags         = each.value.tags
}

module "certificate" {
  source                               = "../../elb/listener_certificate"
  dns_data                             = var.dns_data
  elb_data_map                         = var.elb_data_map
  listener_acm_certificate_key_default = var.listener_acm_certificate_key_default
  listener_dns_alias_enabled_default   = var.listener_dns_alias_enabled_default
  listener_dns_from_zone_key_default   = var.listener_dns_from_zone_key_default
  listener_map                         = local.create_attachment_map
  name_include_app_fields_default      = var.name_include_app_fields_default
  name_infix_default                   = var.name_infix_default
  std_map                              = var.std_map
}
