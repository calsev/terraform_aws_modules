module "credential_secret" {
  source         = "../../secret/data"
  for_each       = var.server_type_to_secret
  ssm_param_name = each.value.ssm_param_name
  sm_secret_name = each.value.sm_secret_name
  sm_secret_key  = each.value.sm_secret_key
  std_map        = var.std_map
}

resource "aws_codebuild_source_credential" "this_credential" {
  for_each    = var.server_type_to_secret
  auth_type   = "PERSONAL_ACCESS_TOKEN" # TODO: Support BitBucket with BASIC_AUTH
  server_type = each.key
  token       = module.credential_secret[each.key].secret
}

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
