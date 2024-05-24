module "key_secret" {
  source                          = "../../secret/random"
  name_include_app_fields_default = var.key_name_include_app_fields_default
  name_infix_default              = var.key_name_infix_default
  policy_create_default           = false
  secret_is_param_default         = var.key_secret_is_param_default
  secret_map                      = local.lx_map
  secret_random_init_type_default = "ssh_key"
  std_map                         = var.std_map
}

resource "aws_key_pair" "generated_key" {
  for_each   = local.lx_map
  key_name   = each.value.name_effective
  public_key = jsondecode(module.key_secret.secret_map[each.key])["public_key"]
  tags       = each.value.tags
}
