module "build_bucket" {
  source     = "../../s3"
  bucket_map = local.bucket_map
  std_map    = var.std_map
}

module "build_log" {
  source  = "../../log_group"
  log_map = local.log_map
  std_map = var.std_map
}
