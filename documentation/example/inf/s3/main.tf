provider "aws" {
  region = local.std_var.aws_region_name
}

provider "aws" {
  alias  = "milan"
  region = "eu-south-1"
}

module "com_lib" {
  source  = "path/to/modules/common"
  std_var = local.std_var
}

module "milan_lib" {
  source = "path/to/modules/common"
  providers = {
    aws = aws.milan
  }
  std_var = merge(local.std_var, {
    aws_region_name = "eu-south-1"
  })
}

module "oregon_bucket" {
  source                                = "path/to/modules/s3/bucket"
  bucket_log_target_bucket_name_default = "example-log"
  bucket_map = {
    example_backup_cal    = {}
    example_backup_marina = {}
    example_cf_template   = {}
    example_data          = {}
    example_deploy        = {}
    example_log = {
      allow_service_logging     = true
      lifecycle_expiration_days = 30
    }
    example_log_public = {
      allow_public              = true
      encryption_disabled       = false # Use only website to access
      lifecycle_expiration_days = 30
    }
    example_package = {}
  }
  name_infix_default = false
  std_map            = module.com_lib.std_map
}

module "milan_bucket" {
  source = "path/to/modules/s3/bucket"
  providers = {
    aws = aws.milan
  }
  bucket_map = {
    "download.milan.example.com" = {
      allow_public = true
      dns_enabled  = true
      name_infix   = false
    }
  }
  bucket_dns_from_zone_key_default = "example.com"
  dns_data                         = data.terraform_remote_state.dns.outputs.data
  std_map                          = module.milan_lib.std_map
}

module "oregon_ap" {
  source = "path/to/modules/s3/access_point"
  ap_map = {
    example_data_ap = {
      bucket_name_effective = module.oregon_bucket.data["example_data"].name_effective
      vpc_key               = "main"
    }
    example_deploy_ap = {
      bucket_name_effective = module.oregon_bucket.data["example_deploy"].name_effective
    }
  }
  ap_name_infix_default = false
  std_map               = module.com_lib.std_map
  vpc_data_map          = data.terraform_remote_state.net.outputs.data.vpc_map
}

module "tf_lock" {
  source  = "path/to/modules/dynamodb/terraform_lock"
  std_map = module.com_lib.std_map
}

module "local_config" {
  source  = "path/to/modules/local_config"
  content = local.output_data
  std_map = module.com_lib.std_map
}
