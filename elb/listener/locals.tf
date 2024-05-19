module "name_map" {
  source                          = "../../name_map"
  name_include_app_fields_default = var.listener_name_include_app_fields_default
  name_infix_default              = var.listener_name_infix_default
  name_map                        = local.l0_map
  std_map                         = var.std_map
}

locals {
  create_attachment_map = {
    for k, v in local.lx_map : k => merge(v, {
      elb_listener_arn = v.is_listener ? aws_lb_listener.this_listener[k].arn : lookup(local.lx_map, v.rule_listener_key, null) == null ? var.elb_data_map[v.elb_key].port_to_protocol_to_listener_map[v.listen_port][v.rule_listener_key].elb_listener_arn : aws_lb_listener.this_listener[v.rule_listener_key].arn
    })
  }
  create_listener_map = {
    for k, v in local.lx_map : k => v if v.is_listener
  }
  create_rule_map = {
    for k, v in local.create_attachment_map : k => v if !v.is_listener
  }
  l0_map = {
    for k, v in var.listener_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      acm_certificate_key                                    = v.acm_certificate_key == null ? var.listener_acm_certificate_key_default : v.acm_certificate_key
      alpn_policy                                            = v.alpn_policy == null ? var.listener_alpn_policy_default : v.alpn_policy
      action_map                                             = v.action_map == null ? var.listener_action_map_default : v.action_map
      elb_key                                                = v.elb_key == null ? var.listener_elb_key_default : v.elb_key
      listen_port                                            = v.listen_port == null ? var.listener_listen_port_default : v.listen_port
      listen_protocol                                        = v.listen_protocol == null ? var.listener_listen_protocol_default : v.listen_protocol
      listen_ssl_policy                                      = v.listen_ssl_policy == null ? var.listener_listen_ssl_policy_default : v.listen_ssl_policy
      mutual_authentication_ignore_client_certificate_expiry = v.mutual_authentication_ignore_client_certificate_expiry == null ? var.listener_mutual_authentication_ignore_client_certificate_expiry_default : v.mutual_authentication_ignore_client_certificate_expiry
      mutual_authentication_mode                             = v.mutual_authentication_mode == null ? var.listener_mutual_authentication_mode_default : v.mutual_authentication_mode
      mutual_authentication_trust_store_arn                  = v.mutual_authentication_trust_store_arn == null ? var.listener_mutual_authentication_trust_store_arn_default : v.mutual_authentication_trust_store_arn
      rule_condition_map                                     = v.rule_condition_map == null ? var.rule_condition_map_default : v.rule_condition_map
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      action_map = {
        for k_act, v_act in local.l1_map[k].action_map : k_act => merge(v_act, {
          action_fixed_response_content_type          = v_act.action_fixed_response_content_type == null ? var.listener_action_fixed_response_content_type_default : v_act.action_fixed_response_content_type
          action_fixed_response_message_body          = v_act.action_fixed_response_message_body == null ? var.listener_action_fixed_response_message_body_default : v_act.action_fixed_response_message_body
          action_fixed_response_status_code           = v_act.action_fixed_response_status_code == null ? var.listener_action_fixed_response_status_code_default : v_act.action_fixed_response_status_code
          action_forward_stickiness_duration_seconds  = v_act.action_forward_stickiness_duration_seconds == null ? var.listener_action_forward_stickiness_duration_seconds_default : v_act.action_forward_stickiness_duration_seconds
          action_forward_stickiness_enabled           = v_act.action_forward_stickiness_enabled == null ? var.listener_action_forward_stickiness_enabled_default : v_act.action_forward_stickiness_enabled
          action_forward_target_group_map             = v_act.action_forward_target_group_map == null ? var.listener_action_forward_target_group_map_default : v_act.action_forward_target_group_map
          action_order                                = v_act.action_order == null ? var.listener_action_order_default : v_act.action_order
          action_redirect_host                        = v_act.action_redirect_host == null ? var.listener_action_redirect_host_default : v_act.action_redirect_host
          action_redirect_path                        = v_act.action_redirect_path == null ? var.listener_action_redirect_path_default : v_act.action_redirect_path
          action_redirect_port                        = v_act.action_redirect_port == null ? var.listener_action_redirect_port_default : v_act.action_redirect_port
          action_redirect_protocol                    = v_act.action_redirect_protocol == null ? var.listener_action_redirect_protocol_default : v_act.action_redirect_protocol
          action_redirect_query                       = v_act.action_redirect_query == null ? var.listener_action_redirect_query_default : v_act.action_redirect_query
          action_redirect_status_code                 = v_act.action_redirect_status_code == null ? var.listener_action_redirect_status_code_default : v_act.action_redirect_status_code
          action_type                                 = v_act.action_type == null ? var.listener_action_type_default : v_act.action_type
          auth_authentication_request_extra_param_map = v_act.auth_authentication_request_extra_param_map == null ? var.listener_auth_authentication_request_extra_param_map_default : v_act.auth_authentication_request_extra_param_map
          auth_cognito_client_app_key                 = v_act.auth_cognito_client_app_key == null ? var.listener_auth_cognito_client_app_key_default : v_act.auth_cognito_client_app_key
          auth_cognito_pool_key                       = v_act.auth_cognito_pool_key == null ? var.listener_auth_cognito_pool_key_default : v_act.auth_cognito_pool_key
          auth_oidc_authorization_endpoint            = v_act.auth_oidc_authorization_endpoint == null ? var.listener_auth_oidc_authorization_endpoint_default : v_act.auth_oidc_authorization_endpoint
          auth_oidc_client_id                         = v_act.auth_oidc_client_id == null ? var.listener_auth_oidc_client_id_default : v_act.auth_oidc_client_id
          auth_oidc_client_secret                     = v_act.auth_oidc_client_secret == null ? var.listener_auth_oidc_client_secret_default : v_act.auth_oidc_client_secret
          auth_oidc_issuer                            = v_act.auth_oidc_issuer == null ? var.listener_auth_oidc_issuer_default : v_act.auth_oidc_issuer
          auth_oidc_token_endpoint                    = v_act.auth_oidc_token_endpoint == null ? var.listener_auth_oidc_token_endpoint_default : v_act.auth_oidc_token_endpoint
          auth_oidc_user_info_endpoint                = v_act.auth_oidc_user_info_endpoint == null ? var.listener_auth_oidc_user_info_endpoint_default : v_act.auth_oidc_user_info_endpoint
          auth_on_unauthenticated_request             = v_act.auth_on_unauthenticated_request == null ? var.listener_auth_on_unauthenticated_request_default : v_act.auth_on_unauthenticated_request
          auth_scope_list                             = v_act.auth_scope_list == null ? var.listener_auth_scope_list_default : v_act.auth_scope_list
          auth_session_cookie_name                    = v_act.auth_session_cookie_name == null ? var.listener_auth_session_cookie_name_default : v_act.auth_session_cookie_name
          auth_session_timeout_seconds                = v_act.auth_session_timeout_seconds == null ? var.listener_auth_session_timeout_seconds_default : v_act.auth_session_timeout_seconds
        })
      }
      alpn_policy_effective = local.l1_map[k].listen_protocol == "TLS" ? local.l1_map[k].alpn_policy : null
      certificate_supported = local.l1_map[k].listen_protocol == "HTTPS" || local.l1_map[k].listen_protocol == "TLS"
      elb_arn               = var.elb_data_map[local.l1_map[k].elb_key].elb_arn
      is_listener           = length(local.l1_map[k].rule_condition_map) == 0
      load_balancer_type    = var.elb_data_map[local.l1_map[k].elb_key].load_balancer_type
      rule_condition_map = {
        for k_rule, v_rule in local.l1_map[k].rule_condition_map : k_rule => merge(v_rule, {
          host_header_pattern_list = v_rule.host_header_pattern_list == null ? var.rule_host_header_pattern_list_default : v_rule.host_header_pattern_list
          http_header_map          = v_rule.http_header_map == null ? var.rule_http_header_map_default : v_rule.http_header_map
          http_request_method_list = v_rule.http_request_method_list == null ? var.rule_http_request_method_list_default : v_rule.http_request_method_list
          path_pattern_list        = v_rule.path_pattern_list == null ? var.rule_path_pattern_list_default : v_rule.path_pattern_list
          query_string_map         = v_rule.query_string_map == null ? var.rule_query_string_map_default : v_rule.query_string_map
          source_ip_list           = v_rule.source_ip_list == null ? var.rule_source_ip_list_default : v_rule.source_ip_list
        })
      }
      rule_listener_key = v.rule_listener_key == null ? var.rule_listener_key_default == null ? local.l1_map[k].listen_protocol : var.rule_listener_key_default : v.rule_listener_key
    }
  }
  l3_map = {
    for k, v in local.l0_map : k => {
      acm_certificate_arn = local.l2_map[k].certificate_supported ? var.dns_data.region_domain_cert_map[var.std_map.aws_region_name][local.l1_map[k].acm_certificate_key].certificate_arn : null
      action_map = {
        for k_act, v_act in local.l2_map[k].action_map : k_act => merge(v_act, {
          action_forward_target_group_map = {
            for k_fwd, v_fwd in v_act.action_forward_target_group_map : k_fwd => merge(v_fwd, {
              target_group_arn    = var.elb_target_data_map[k_fwd].target_group_arn
              target_group_weight = v_fwd.target_group_weight == null ? var.listener_action_forward_target_group_weight_default == null ? 100 / max(1, length(v_act.action_forward_target_group_map)) : var.listener_action_forward_target_group_weight_default : v_fwd.target_group_weight
            })
          }
          action_redirect_port        = local.l1_map[k].action_map[k_act].action_redirect_port == null ? "#{port}" : local.l2_map[k].action_map[k_act].action_redirect_port
          auth_cognito_client_app_id  = v_act.auth_cognito_client_app_key == null ? null : var.cognito_data_map[v_act.auth_cognito_pool_key].user_pool_client.client_app_map[v_act.auth_cognito_client_app_key].client_app_id
          auth_cognito_user_pool_arn  = v_act.auth_cognito_pool_key == null ? null : var.cognito_data_map[v_act.auth_cognito_pool_key].user_pool_arn
          auth_cognito_user_pool_fqdn = v_act.auth_cognito_pool_key == null ? null : var.cognito_data_map[v_act.auth_cognito_pool_key].user_pool_fqdn
          auth_scope_string           = join(" ", v_act.auth_scope_list)
        })
      }
      listen_ssl_policy_effective = local.l2_map[k].certificate_supported ? local.l1_map[k].listen_ssl_policy : null
    }
  }
  lx_map = {
    for k, v in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k], local.l3_map[k])
  }
  output_data = {
    for k, v in local.lx_map : k => merge(
      {
        for k_attr, v_attr in v : k_attr => v_attr if !contains([], k_attr)
      },
      {
        cert                    = module.certificate.data[k]
        elb_listener_arn        = v.is_listener ? aws_lb_listener.this_listener[k].arn : null
        elb_listener_rule_arn   = v.is_listener ? null : aws_lb_listener_rule.this_rule[k].arn
        elb_listener_target_arn = local.create_attachment_map[k].elb_listener_arn
      }
    )
  }
}
