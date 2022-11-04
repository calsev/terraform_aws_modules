module "build_bucket" {
  source     = "../s3"
  bucket_map = local.bucket_map
  std_map    = var.std_map
}

module "build_log" {
  source             = "../log_group"
  create_policy      = var.create_policy
  log_retention_days = var.log_retention_days
  name               = "codebuild"
  policy_name_prefix = var.policy_name_prefix
  std_map            = var.std_map
}
