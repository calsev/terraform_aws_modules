locals {
  domain_map = {
    "cdn.example.com" : {}
    "cognito.example.com" : {}
    "example.com" : {}
  }
  output_data = {
    cache_policy_id_map = {
      max_cache = aws_cloudfront_cache_policy.cdn_cache_policy_max_cache.id
    }
    domain_cert_map = module.cert.data
    origin_request_policy_id_map = {
      max_cache = aws_cloudfront_origin_request_policy.cdn_origin_policy_max_cache.id
    }
    web_acl_arn = module.waf.web_acl_arn
  }
  std_var = {
    app             = "inf-cdng"
    aws_region_name = "us-east-1" # These resources MUST be created here
    env             = "prod"
  }
}
