resource "aws_wafv2_web_acl" "this_waf_acl" {
  for_each = local.lx_map
  # association_config # TODO
  # captcha_config # TODO
  # challenge_config # TODO
  # custom_response_body # TODO
  default_action {
    allow {}
  }
  name = each.value.name_effective
  rule {
    action {
      block {
        # custom_response TODO
      }
    }
    # captcha_config # TODO
    name     = each.value.rate_limit_ip_rule_name
    priority = 1
    # override_action # TODO
    rule_label {
      name = each.value.rate_limit_ip_rule_name
    }
    statement {
      rate_based_statement {
        aggregate_key_type = "IP" # TODO
        # custom_key # TODO
        # forwarded_ip_config # TODO
        limit = each.value.rate_limit_ip_5_minute
        # scope_down_statement # TODO
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = each.value.rate_limit_ip_rule_metric_name
      sampled_requests_enabled   = true
    }
  }
  scope         = each.value.scope
  tags          = each.value.tags
  token_domains = [] # TODO
  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = each.value.name_effective
    sampled_requests_enabled   = true
  }
}
