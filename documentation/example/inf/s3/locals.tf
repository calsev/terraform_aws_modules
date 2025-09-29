locals {
  output_data = {
    bucket = {
      (module.milan_lib.std_map.aws_region_name) = module.milan_bucket.data
      (module.com_lib.std_map.aws_region_name)   = module.oregon_bucket.data
    }
    public_access = module.public_access_block.data
  }
  std_var = {
    app             = "inf-s3"
    aws_region_name = "us-west-2"
    env             = "prod"
  }
}
