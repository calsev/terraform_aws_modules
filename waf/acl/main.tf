resource "aws_wafv2_web_acl" "this_waf_acl" {
  for_each = local.lx_map
  association_config {
    request_body {
      dynamic "api_gateway" {
        for_each = each.value.scope == "REGIONAL" ? { this = {} } : {}
        content {
          default_size_inspection_limit = "KB_${each.value.size_inspection_limit_api_gateway_kb}"
        }
      }
      dynamic "app_runner_service" {
        for_each = each.value.scope == "REGIONAL" ? { this = {} } : {}
        content {
          default_size_inspection_limit = "KB_${each.value.size_inspection_limit_app_runner_service_kb}"
        }
      }
      dynamic "cloudfront" {
        for_each = each.value.scope == "CLOUDFRONT" ? { this = {} } : {}
        content {
          default_size_inspection_limit = "KB_${each.value.size_inspection_limit_cloudfront_distribution_kb}"
        }
      }
      dynamic "cognito_user_pool" {
        for_each = each.value.scope == "REGIONAL" ? { this = {} } : {}
        content {
          default_size_inspection_limit = "KB_${each.value.size_inspection_limit_cognito_user_pool_kb}"
        }
      }
      dynamic "verified_access_instance" {
        for_each = each.value.scope == "REGIONAL" ? { this = {} } : {}
        content {
          default_size_inspection_limit = "KB_${each.value.size_inspection_limit_verified_access_instance_kb}"
        }
      }
    }
  }
  captcha_config {
    immunity_time_property {
      immunity_time = each.value.captcha_immunity_time_seconds
    }
  }
  challenge_config {
    immunity_time_property {
      immunity_time = each.value.challenge_immunity_time_seconds
    }
  }
  dynamic "custom_response_body" {
    for_each = each.value.custom_response_map
    content {
      key          = custom_response_body.key
      content      = custom_response_body.value.content
      content_type = custom_response_body.content_type
    }
  }
  default_action {
    dynamic "allow" {
      for_each = each.value.default_action_type == "allow" ? { this = {} } : {}
      content {
        dynamic "custom_request_handling" {
          for_each = length(each.value.default_action_header_map) == 0 ? {} : { this = {} }
          content {
            dynamic "insert_header" {
              for_each = each.value.default_action_header_map
              content {
                name  = insert_header.key
                value = insert_header.value
              }
            }
          }
        }
      }
    }
    dynamic "block" {
      for_each = each.value.default_action_type == "block" ? { this = {} } : {}
      content {
        custom_response {
          custom_response_body_key = each.value.default_action_block_custom_response_body_key
          response_code            = each.value.default_action_block_response_code
          dynamic "response_header" {
            for_each = each.value.default_action_header_map
            content {
              name  = response_header.key
              value = response_header.value
            }
          }
        }
      }
    }
  }
  name = each.value.name_effective
  dynamic "rule" {
    for_each = each.value.rule_map
    content {
      action {
        dynamic "allow" {
          for_each = rule.value.type == "allow" ? { this = {} } : {}
          content {
            custom_request_handling {
              dynamic "insert_header" {
                for_each = rule.value.action_header_map
                content {
                  name  = insert_header.key
                  value = insert_header.value
                }
              }
            }
          }
        }
        dynamic "block" {
          for_each = rule.value.type == "block" ? { this = {} } : {}
          content {
            custom_response {
              custom_response_body_key = rule.value.action_block_custom_response_body_key
              response_code            = rule.value.action_block_response_code
              dynamic "response_header" {
                for_each = rule.value.action_header_map
                content {
                  name  = response_header.key
                  value = response_header.value
                }
              }
            }
          }
        }
        dynamic "captcha" {
          for_each = rule.value.type == "captcha" ? { this = {} } : {}
          content {
            custom_request_handling {
              dynamic "insert_header" {
                for_each = rule.value.action_header_map
                content {
                  name  = insert_header.key
                  value = insert_header.value
                }
              }
            }
          }
        }
        dynamic "challenge" {
          for_each = rule.value.type == "challenge" ? { this = {} } : {}
          content {
            custom_request_handling {
              dynamic "insert_header" {
                for_each = rule.value.action_header_map
                content {
                  name  = insert_header.key
                  value = insert_header.value
                }
              }
            }
          }
        }
        dynamic "count" {
          for_each = rule.value.type == "count" ? { this = {} } : {}
          content {
            custom_request_handling {
              dynamic "insert_header" {
                for_each = rule.value.action_header_map
                content {
                  name  = insert_header.key
                  value = insert_header.value
                }
              }
            }
          }
        }
      }
      captcha_config {
        immunity_time_property {
          immunity_time = rule.value.captcha_immunity_time_seconds
        }
      }
      name = rule.value.name
      # override_action # GROUP
      priority = rule.value.priority
      rule_label {
        name = rule.value.name
      }
      statement {
        # and_statement # STMT
        # byte_match_statement # STMT
        # geo_match_statement # STMT
        # ip_set_reference_statement # STMT
        # label_match_statement # STMT
        # managed_rule_group_statement # STMT
        # not_statement # STMT
        # or_statement # STMT
        rate_based_statement {
          aggregate_key_type = rule.value.aggregation_key_type
          # custom_key # TODO
          evaluation_window_sec = rule.value.aggregation_window_seconds
          # forwarded_ip_config # TODO
          limit = rule.value.limit
          # scope_down_statement # TODO
        }
        # regex_match_statement # STMT
        # regex_pattern_set_reference_statement # STMT
        # rule_group_reference_statement # STMT
        # size_constraint_statement # STMT
        # sqli_match_statement # STMT
        # xss_match_statement # STMT
      }
      visibility_config {
        cloudwatch_metrics_enabled = rule.value.metric_enabled
        metric_name                = rule.value.metric_name
        sampled_requests_enabled   = rule.value.metric_sampled_requests_enabled
      }
    }
  }
  scope         = each.value.scope
  tags          = each.value.tags
  token_domains = each.value.token_domain_allow_list
  visibility_config {
    cloudwatch_metrics_enabled = each.value.metric_enabled
    metric_name                = each.value.name_effective
    sampled_requests_enabled   = each.value.metric_sampled_requests_enabled
  }
}
