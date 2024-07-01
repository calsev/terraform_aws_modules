provider "aws" {
  region = local.std_var.aws_region_name
}

module "com_lib" {
  source  = "path/to/modules/common"
  std_var = local.std_var
}

module "waf" {
  source = "path/to/modules/waf/acl"
  waf_map = {
    basic_rate_limit = {
    }
  }
  std_map = module.com_lib.std_map
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
