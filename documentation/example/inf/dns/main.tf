provider "aws" {
  alias  = "oregon"
  region = "us-west-2"
}

provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
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

module "virginia_lib" {
  source = "path/to/modules/common"
  providers = {
    aws = aws.virginia
  }
  std_var = merge(local.std_var, {
    aws_region_name = "us-east-1"
  })
}

module "dns_account" {
  source = "path/to/modules/dns/aws_account"
  providers = {
    aws = aws.virginia
  }
  std_map = module.virginia_lib.std_map
}

module "dns_zone" {
  source = "path/to/modules/dns/zone"
  providers = {
    aws = aws.virginia
  }
  domain_mx_url_list_default = [
    "5 gmr-smtp-in.l.google.com",
    "10 alt1.gmr-smtp-in.l.google.com",
    "20 alt2.gmr-smtp-in.l.google.com",
    "30 alt3.gmr-smtp-in.l.google.com",
    "40 alt4.gmr-smtp-in.l.google.com",
  ]
  domain_to_dns_zone_map = {
    "example.com" : {
      mx_url_list = [
        "1 smtp.google.com",
      ]
    },
    "example2.net" : {},
    "example3.com" : {},
  }
  std_map = module.virginia_lib.std_map
}

module "log_group" {
  source = "path/to/modules/cw/log_group"
  providers = {
    aws = aws.virginia
  }
  log_map = {
    "io.example.com" = {}
  }
  log_retention_days_default = 3
  name_prefix_default        = "/aws/route53/"
  std_map                    = module.virginia_lib.std_map
}

module "sd_zone_public" {
  source = "path/to/modules/dns/sd_public"
  providers = {
    aws = aws.oregon
  }
  dns_data                       = local.o1_map
  log_data_map                   = module.log_group.data
  std_map                        = module.oregon_lib.std_map
  zone_dns_from_zone_key_default = "example.com"
  zone_map = {
    "io.example.com" = {
      log_group_key = "io.example.com"
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
    "api_dev.example.com"  = {}
    "auth_api.example.com" = {}
    "lambda.example.com"   = {}
    "web.example.com"      = {}
  }
  domain_dns_from_zone_key_default = "example.com"
  std_map                          = module.oregon_lib.std_map
}

module "dns_record" {
  source                           = "path/to/modules/dns/record"
  dns_data                         = local.o1_map
  record_dns_from_zone_key_default = "example.com"
  record_map = {
    email_dkim = {
      dns_from_fqdn   = "google._domainkey"
      dns_record_list = ["v=DKIM1; k=rsa; p=some\"\"key"]
      dns_type        = "TXT"
    }
    email_dmarc = {
      dns_from_fqdn   = "_dmarc.example.com"
      dns_record_list = ["v=DMARC1; p=none; rua=mailto:dmarc@example.com; ruf=mailto:dmarc@example.com; sp=none; aspf=s; adkim=s; fo=1;"]
      dns_type        = "TXT"
    }
    root_txt = {
      dns_from_fqdn = "example.com"
      dns_record_list = [
        "google-site-verification=some-hash",  # Google Workspace validation
        "v=spf1 include:_spf.google.com ~all", # Email SPF
      ]
      dns_type = "TXT"
    }
  }
  std_map = module.virginia_lib.std_map
}

module "local_config" {
  source  = "path/to/modules/local_config"
  content = local.output_data
  std_map = module.oregon_lib.std_map
}
