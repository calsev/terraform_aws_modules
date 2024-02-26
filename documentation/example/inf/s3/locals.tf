locals {
  bucket_map = {
    example_backup_cal    = {}
    example_backup_marina = {}
    example_cf_template   = {}
    example_data          = {}
    example_deploy        = {}
    example_log = {
      lifecycle_expiration_days = 30
    }
    example_log_public = {
      allow_public              = true
      encryption_disabled       = false # Use only website to access
      lifecycle_expiration_days = 30
    }
    example_package = {}
  }
  output_data = {
    ap = {
      (module.com_lib.std_map.aws_region_name) = module.oregon_ap.data
    }
    bucket = {
      (module.milan_lib.std_map.aws_region_name) = module.milan_bucket.data
      (module.com_lib.std_map.aws_region_name)   = module.oregon_bucket.data
    }
    dynamodb = module.tf_lock.data
  }
  std_var = {
    app             = "inf-s3"
    aws_region_name = "us-west-2"
    env             = "prod"
  }
}
