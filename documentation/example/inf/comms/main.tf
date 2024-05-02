provider "aws" {
  region = local.std_var.aws_region_name
}

module "com_lib" {
  source  = "path/to/modules/common"
  std_var = local.std_var
}

module "mobile_analytics_iam" {
  source  = "path/to/modules/iam/app/mobile_analytics"
  std_map = module.com_lib.std_map
}

module "ses_config" {
  source = "path/to/modules/ses/configuration_set"
  config_map = {
    default = {}
  }
  std_map = module.com_lib.std_map
}

module "ses_domain" {
  source                               = "path/to/modules/ses/domain_identity"
  config_data_map                      = module.ses_config.data
  dns_data                             = data.terraform_remote_state.dns.outputs.data
  domain_configuration_set_key_default = "default"
  domain_dns_from_zone_key_default     = "example.com"
  domain_map = {
    "example.com" = {
    }
  }
  std_map = module.com_lib.std_map
}

module "ses_email" {
  source                               = "path/to/modules/ses/email_identity"
  config_data_map                      = module.ses_config.data
  domain_configuration_set_key_default = "default"
  domain_map = {
    "user@example.com"    = {}
    "devops@example.com"  = {}
    "noreply@example.com" = {}
  }
  std_map = module.com_lib.std_map
}

module "local_config" {
  source  = "path/to/modules/local_config"
  content = local.output_data
  std_map = module.com_lib.std_map
}
