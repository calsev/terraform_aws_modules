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
  source = "path/to/modules/dns/zone"
  providers = {
    aws = aws.oregon
  }
  domain_mx_url_list_default = [
    "5 gmr-smtp-in.l.google.com",
    "10 alt1.gmr-smtp-in.l.google.com",
    "20 alt2.gmr-smtp-in.l.google.com",
    "30 alt3.gmr-smtp-in.l.google.com",
    "40 alt4.gmr-smtp-in.l.google.com",
  ]
  domain_to_dns_zone_map = {
    "example.com" : {},
    "example2.net" : {},
    "example3.com" : {},
  }
}

module "sd_zone_public" {
  source = "path/to/modules/dns/sd_public"
  providers = {
    aws = aws.oregon
  }
  dns_data = local.o1_map
  std_map  = module.oregon_lib.std_map
  zone_map = {
    "io.example.com" = {
      dns_from_zone_key = "example.com"
    }
  }
}

module "cert_oregon" {
  source = "path/to/modules/cert"
  providers = {
    aws = aws.oregon
  }
  dns_data = local.o1_map
  domain_map = {
    "elb.example.com"      = {}
    "api.example.com"      = {}
    "auth_api.example.com" = {}
    "web.example.com"      = {}
    "web_dev.example.com"  = {}
  }
  domain_dns_from_zone_key_default = "example.com"
  std_map                          = module.oregon_lib.std_map
}

module "local_config" {
  source  = "path/to/modules/local_config"
  content = local.output_data
  std_map = module.oregon_lib.std_map
}
