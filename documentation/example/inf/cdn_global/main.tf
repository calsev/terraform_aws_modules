provider "aws" {
  region = local.std_var.aws_region_name
}

module "com_lib" {
  source  = "path/to/modules/common"
  std_var = local.std_var
}

module "s3_bucket" {
  source                                = "path/to/modules/s3/bucket"
  bucket_log_target_bucket_name_default = "aws-waf-logs-example-global"
  bucket_map = {
    aws_waf_logs_example_global = { # Must start with prefix
      allow_log_waf                     = true
      enforce_object_ownership          = false # Not allowed for CDN logging
      lifecycle_expiration_days         = 7     # This is for CDN logs, so keep it short
      lifecycle_version_expiration_days = 1
      name_infix                        = false
    }
  }
  std_map = module.com_lib.std_map
}

module "waf" {
  source = "path/to/modules/waf/acl"
  # log_destination_s3_bucket_key_list_default = ["aws_waf_logs_example_global"]
  waf_map = {
    basic_rate_limit = {
    }
  }
  s3_data_map = module.s3_bucket.data
  std_map     = module.com_lib.std_map
}

module "cache_policy" {
  source = "path/to/modules/cdn/cache_policy"
  policy_map = {
    max_cache = {}
  }
  std_map = module.com_lib.std_map
}

module "origin_policy" {
  source = "path/to/modules/cdn/origin_request_policy"
  policy_map = {
    max_cache = {}
  }
  std_map = module.com_lib.std_map
}

module "cert" {
  source   = "path/to/modules/cert"
  dns_data = data.terraform_remote_state.dns.outputs.data
  domain_map = {
    "cdn.example.com" : {}
    "cognito.example.com" : {}
    "example.com" : {}
  }
  domain_dns_from_zone_key_default = "example.com"
  std_map                          = module.com_lib.std_map
}

module "local_config" {
  source  = "path/to/modules/local_config"
  content = local.output_data
  std_map = module.com_lib.std_map
}
