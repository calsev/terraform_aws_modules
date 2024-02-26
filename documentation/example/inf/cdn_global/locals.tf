locals {
  output_data = {
    cache_policy_map          = module.cache_policy.data
    domain_cert_map           = module.cert.data
    origin_request_policy_map = module.origin_policy.data
    web_acl_map               = module.waf.data
  }
  std_var = {
    app             = "inf-cdng"
    aws_region_name = "us-east-1" # These resources MUST be created here
    env             = "prod"
  }
}
