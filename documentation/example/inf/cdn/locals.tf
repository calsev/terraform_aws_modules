locals {
  output_data = {
    cdn       = module.cdn_example.data
    key       = module.public_key.data
    key_group = module.key_group.data
  }
  std_var = {
    app             = "inf-cdn"
    aws_region_name = "us-west-2"
    env             = "prod"
  }
}
