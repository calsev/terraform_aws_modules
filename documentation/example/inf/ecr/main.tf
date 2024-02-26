provider "aws" {
  region = local.std_var.aws_region_name
}

module "com_lib" {
  source  = "path/to/modules/common"
  std_var = local.std_var
}

module "repo" {
  source = "path/to/modules/ecr/repo"
  repo_map = {
    ubuntu = {
      # These tags are for ecr-mirror
      base_image = "ubuntu"
      image_tag_list = [
        "latest",
      ]
    }
  }
  std_map = module.com_lib.std_map
}

module "dns_alias" {
  source                           = "path/to/modules/dns/record"
  dns_data                         = data.terraform_remote_state.dns.outputs.data
  record_dns_from_zone_key_default = "example.com"
  record_dns_type_default          = "CNAME"
  record_map = {
    "ecr.example.com" = {
      dns_record_list = ["${module.com_lib.std_map.aws_account_id}.dkr.ecr.${module.com_lib.std_map.aws_region_name}.amazonaws.com"]
    }
  }
  std_map = module.com_lib.std_map
}

module "local_config" {
  source  = "path/to/modules/local_config"
  content = local.output_data
  std_map = module.com_lib.std_map
}
