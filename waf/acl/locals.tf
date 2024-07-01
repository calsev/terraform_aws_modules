module "name_map" {
  source   = "../../name_map"
  name_map = local.l0_map
  std_map  = var.std_map
}

locals {
  l0_map = {
    for k, v in var.waf_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      captcha_immunity_time_seconds                     = v.captcha_immunity_time_seconds == null ? var.waf_captcha_immunity_time_seconds_default : v.captcha_immunity_time_seconds
      challenge_immunity_time_seconds                   = v.challenge_immunity_time_seconds == null ? var.waf_challenge_immunity_time_seconds_default : v.challenge_immunity_time_seconds
      custom_response_map                               = v.custom_response_map == null ? var.waf_custom_response_map_default : v.custom_response_map
      default_action_block_custom_response_body_key     = v.default_action_block_custom_response_body_key == null ? var.waf_default_action_block_custom_response_body_key_default : v.default_action_block_custom_response_body_key
      default_action_block_response_code                = v.default_action_block_response_code == null ? var.waf_default_action_block_response_code_default : v.default_action_block_response_code
      default_action_header_map                         = v.default_action_header_map == null ? var.waf_default_action_header_map_default : v.default_action_header_map
      default_action_type                               = v.default_action_type == null ? var.waf_default_action_type_default : v.default_action_type
      metric_enabled                                    = v.metric_enabled == null ? var.waf_metric_enabled_default : v.metric_enabled
      metric_sampled_requests_enabled                   = v.metric_sampled_requests_enabled == null ? var.waf_metric_sampled_requests_enabled_default : v.metric_sampled_requests_enabled
      rule_map                                          = v.rule_map == null ? var.waf_rule_map_default : v.rule_map
      scope                                             = v.scope == null ? var.waf_scope_default : v.scope
      size_inspection_limit_api_gateway_kb              = v.size_inspection_limit_api_gateway_kb == null ? var.waf_size_inspection_limit_api_gateway_kb_default : v.size_inspection_limit_api_gateway_kb
      size_inspection_limit_app_runner_service_kb       = v.size_inspection_limit_app_runner_service_kb == null ? var.waf_size_inspection_limit_app_runner_service_kb_default : v.size_inspection_limit_app_runner_service_kb
      size_inspection_limit_cloudfront_distribution_kb  = v.size_inspection_limit_cloudfront_distribution_kb == null ? var.waf_size_inspection_limit_cloudfront_distribution_kb_default : v.size_inspection_limit_cloudfront_distribution_kb
      size_inspection_limit_cognito_user_pool_kb        = v.size_inspection_limit_cognito_user_pool_kb == null ? var.waf_size_inspection_limit_cognito_user_pool_kb_default : v.size_inspection_limit_cognito_user_pool_kb
      size_inspection_limit_verified_access_instance_kb = v.size_inspection_limit_verified_access_instance_kb == null ? var.waf_size_inspection_limit_verified_access_instance_kb_default : v.size_inspection_limit_verified_access_instance_kb
      token_domain_allow_list                           = v.token_domain_allow_list == null ? var.waf_token_domain_allow_list_default : v.token_domain_allow_list
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      custom_response_map = {
        for k_custom, v_custom in local.l1_map[k].custom_response_map : k_custom => merge(v_custom, {
          content      = v_custom.content == null ? var.waf_custom_response_content_default : v_custom.content
          content_type = v_custom.content_type == null ? var.waf_custom_response_content_type_default : v_custom.content_type
        })
      }
      rule_map = {
        for k_rule, v_rule in local.l1_map[k].rule_map : k_rule => merge(v_rule, {
          action_block_custom_response_body_key = v_rule.action_block_custom_response_body_key == null ? var.waf_rule_action_block_custom_response_body_key_default : v_rule.action_block_custom_response_body_key
          action_block_response_code            = v_rule.action_block_response_code == null ? var.waf_rule_action_block_response_code_default : v_rule.action_block_response_code
          action_header_map                     = v_rule.action_header_map == null ? var.waf_rule_action_header_map_default : v_rule.action_header_map
          aggregation_key_type                  = v_rule.aggregation_key_type == null ? var.waf_rule_aggregation_key_type_default : v_rule.aggregation_key_type
          aggregation_window_seconds            = v_rule.aggregation_window_seconds == null ? var.waf_rule_aggregation_window_seconds_default : v_rule.aggregation_window_seconds
          captcha_immunity_time_seconds         = v_rule.captcha_immunity_time_seconds == null ? local.l1_map[k].captcha_immunity_time_seconds : v_rule.captcha_immunity_time_seconds
          limit                                 = v_rule.limit == null ? var.waf_rule_limit_default : v_rule.limit
          metric_enabled                        = v_rule.metric_enabled == null ? var.waf_rule_metric_enabled_default : v_rule.metric_enabled
          metric_sampled_requests_enabled       = v_rule.metric_sampled_requests_enabled == null ? var.waf_rule_metric_sampled_requests_enabled_default : v_rule.metric_sampled_requests_enabled
          name                                  = replace("${k}_${k_rule}", var.std_map.name_replace_regex, "-")
          priority                              = v_rule.priority == null ? var.waf_rule_priority_default : v_rule.priority
          type                                  = v_rule.type == null ? var.waf_rule_type_default : v_rule.type
        })
      }
    }
  }
  l3_map = {
    for k, v in local.l0_map : k => {
      rule_map = {
        for k_rule, v_rule in local.l2_map[k].rule_map : k_rule => merge(v_rule, {
          metric_name = "waf-${v_rule.name}"
        })
      }
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
        waf_arn = aws_wafv2_web_acl.this_waf_acl[k].arn
      }
    )
  }
}
