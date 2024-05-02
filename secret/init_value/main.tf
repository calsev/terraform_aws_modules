module "initial_password" {
  source                               = "../../random/password"
  random_map                           = local.create_init_password_map
  random_special_character_set_default = var.secret_random_special_character_set_default
}

module "initial_tls_key" {
  source  = "../../random/tls_key"
  key_map = local.create_init_tls_key_map
}
