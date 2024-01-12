provider "aws" {
  region = local.std_var.aws_region_name
}

module "com_lib" {
  source  = "path/to/modules/common"
  std_var = local.std_var
}

module "waf" {
  source   = "path/to/modules/waf"
  acl_name = "WafAclCdnRateLimit-Ys2UmVItyhrx" # This resource was imported
  name     = "cdn"
  std_map  = module.com_lib.std_map
}

module "cert" {
  source                           = "path/to/modules/cert"
  dns_data                         = data.terraform_remote_state.dns.outputs.data
  domain_map                       = local.domain_map
  domain_validation_domain_default = "example.com"
  std_map                          = module.com_lib.std_map
}

module "local_config" {
  source  = "path/to/modules/local_config"
  content = local.output_data
  std_map = module.com_lib.std_map
}
