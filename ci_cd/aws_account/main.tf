module "build_bucket" {
  source     = "../../s3/bucket"
  bucket_map = local.bucket_map
  std_map    = var.std_map
}

module "build_log" {
  source  = "../../cw/log_group"
  log_map = local.log_map
  std_map = var.std_map
}
