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
  source = "path/to/modules/s3"

  bucket_map                = local.bucket_map
  bucket_name_infix_default = false
  std_map                   = module.com_lib.std_map
}

module "milan_bucket" {
  source = "path/to/modules/s3"
  providers = {
    aws = aws.milan
  }

  bucket_map = {
    "download.milan.example.com" = {
      allow_public = true
      name_infix   = false
      website_fqdn = "download.milan.example.com"
    }
  }
  bucket_website_domain_default = "example.com"
  dns_data                      = data.terraform_remote_state.dns.outputs.data
  std_map                       = module.milan_lib.std_map
}

module "oregon_ap" {
  source = "path/to/modules/s3_access_point"
  ap_map = {
    example-data-ap = {
      bucket_name_effective = module.oregon_bucket.data["example-data"].name_effective
      vpc_key               = "main"
    }
    example-deploy-ap = {
      bucket_name_effective = module.oregon_bucket.data["example-deploy"].name_effective
    }
  }
  ap_name_infix_default = false
  std_map               = module.com_lib.std_map
  vpc_data_map          = data.terraform_remote_state.net.outputs.data.vpc_map
}

module "tf_lock" {
  source  = "path/to/modules/dynamodb_terraform_lock"
  std_map = module.com_lib.std_map
}

module "local_config" {
  source  = "path/to/modules/local_config"
  content = local.output_data
  std_map = module.com_lib.std_map
}
