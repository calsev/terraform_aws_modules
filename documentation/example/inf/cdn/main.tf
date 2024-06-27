provider "aws" {
  region = local.std_var.aws_region_name
}

module "com_lib" {
  source  = "path/to/modules/common"
  std_var = local.std_var
}

module "public_key" {
  source = "path/to/modules/cdn/public_key"
  key_map = {
    signing_key_1 = {}
    signing_key_2 = {
      secret_is_param = true
    }
  }
  std_map = module.com_lib.std_map
}

module "key_group" {
  source = "path/to/modules/cdn/public_key_group"
  group_map = {
    signing_group = {
      key_key_list = [
        "signing_key_1",
        "signing_key_2",
      ]
    }
  }
  key_data_map = module.public_key.data
  std_map      = module.com_lib.std_map
}

module "cdn_example" {
  source                                = "path/to/modules/cdn/distribution"
  bucket_log_target_bucket_name_default = "example-log"
  cdn_global_data                       = data.terraform_remote_state.cdn_global.outputs.data
  domain_map = {
    "cdn.example.com" : {
      origin_fqdn = "cdn-bucket.example.com"
      # trusted_key_group_key_list = ["signing_group"] # This makes the CDN private
    }
  }
  domain_dns_from_zone_key_default = "example.com"
  dns_data                         = data.terraform_remote_state.dns.outputs.data
  key_group_data_map               = module.key_group.data
  std_map                          = module.com_lib.std_map
}

module "local_config" {
  source  = "path/to/modules/local_config"
  content = local.output_data
  std_map = module.com_lib.std_map
}
