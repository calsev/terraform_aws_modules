provider "aws" {
  region = local.std_var.aws_region_name
}

module "com_lib" {
  source  = "path/to/modules/common"
  std_var = local.std_var
}

module "vpc_stack" {
  source                   = "path/to/modules/vpc/stack"
  std_map                  = module.com_lib.std_map
  vpc_map                  = local.vpc_map
  vpc_nat_multi_az_default = false
}

module "load_balancer" {
  source                             = "path/to/modules/elb/load_balancer"
  dns_data                           = data.terraform_remote_state.dns.outputs.data
  elb_access_log_bucket_default      = "example-log"
  elb_access_log_enabled_default     = true
  elb_connection_log_bucket_default  = "example-log"
  elb_connection_log_enabled_default = true
  elb_dns_from_zone_key_default      = "example.com"
  elb_map = {
    main = {
      acm_certificate_fqdn = "elb.example.com"
    }
  }
  std_map         = module.com_lib.std_map
  vpc_data_map    = module.vpc_stack.data.vpc_map
  vpc_key_default = "main"
}

module "local_config" {
  source  = "path/to/modules/local_config"
  content = local.output_data
  std_map = module.com_lib.std_map
}
