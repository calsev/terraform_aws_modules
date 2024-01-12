provider "aws" {
  alias  = "oregon"
  region = "us-west-2"
}

module "oregon_lib" {
  source = "path/to/modules/common"
  providers = {
    aws = aws.oregon
  }
  std_var = merge(local.std_var, {
    aws_region_name = "us-west-2"
  })
}

module "dns_zone" {
  source = "path/to/modules/dns_zone"
  providers = {
    aws = aws.oregon
  }
  domain_to_dns_zone_map = local.domain_to_dns_zone_map
}

module "sd_zone_public" {
  source = "path/to/modules/dns_sd_public"
  providers = {
    aws = aws.oregon
  }
  std_map   = module.oregon_lib.std_map
  ttl_map   = local.ttl_map
  zone_list = local.sd_zone_list
}

module "cert_oregon" {
  source = "path/to/modules/cert"
  providers = {
    aws = aws.oregon
  }
  dns_data                         = local.o1_map
  domain_map                       = local.region_map[module.oregon_lib.std_map.aws_region_name].cert_map
  domain_validation_domain_default = "example.com"
  std_map                          = module.oregon_lib.std_map
}

module "local_config" {
  source  = "path/to/modules/local_config"
  content = local.output_data
  std_map = module.oregon_lib.std_map
}
