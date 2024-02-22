module "key_secret" {
  source                          = "../../secret/random"
  secret_map                      = local.lx_map
  secret_name_infix_default       = var.key_name_infix_default
  secret_is_param_default         = var.key_secret_is_param_default
  secret_random_init_type_default = "tls_key"
  policy_access_list_default      = var.policy_access_list_default
  policy_create_default           = var.policy_create_default
  std_map                         = var.std_map
}

resource "aws_cloudfront_public_key" "this_key" {
  for_each    = local.lx_map
  encoded_key = jsondecode(module.key_secret.secret_map[each.key])["public_key"]
  name        = each.value.name_effective
}
