locals {
  bucket_map = {
    example-backup-cal    = {}
    example-backup-marina = {}
    example-cf-template   = {}
    example-data          = {}
    example-deploy        = {}
    example-log = {
      lifecycle_expiration_days = 30
    }
    example-log-public = {
      allow_public              = true
      encryption_disabled       = false # Use only website to access
      lifecycle_expiration_days = 30
    }
    example-package = {}
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
