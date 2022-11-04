module "credential_secret" {
  source         = "../secret"
  for_each       = var.server_type_to_secret
  ssm_param_name = each.value.ssm_param_name
  sm_secret_arn  = each.value.sm_secret_arn
  sm_secret_key  = each.value.sm_secret_key
}

resource "aws_codebuild_source_credential" "this_credential" {
  for_each    = var.server_type_to_secret
  auth_type   = "PERSONAL_ACCESS_TOKEN" # TODO: Support BitBucket with BASIC_AUTH
  server_type = each.key
  token       = module.credential_secret[each.key].secret
}
