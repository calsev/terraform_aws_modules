
resource "aws_wafv2_web_acl" "this_waf_acl" {
  default_action {
    allow {}
  }
  name = var.acl_name
  rule {
    action {
      block {}
    }
    name     = "LimitRate"
    priority = 1
    statement {
      rate_based_statement {
        aggregate_key_type = "IP"
        limit              = 100
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "WafAclCdnRateLimitRule"
      sampled_requests_enabled   = true
    }
  }
  scope = "CLOUDFRONT"
  tags  = local.tags
  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "WafAclCdnRateLimit"
    sampled_requests_enabled   = true
  }
}
