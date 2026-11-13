module "secret" {
  source                                      = "../../sm/secret"
  name_include_app_fields_default             = var.name_include_app_fields_default
  name_infix_default                          = var.name_infix_default
  secret_map                                  = local.create_secret_map
  secret_random_special_character_set_default = var.user_password_special_character_set_default
  std_map                                     = var.std_map
}

resource "random_password" "default_user" {
  for_each         = local.lx_map
  length           = 64
  override_special = var.user_password_special_character_set_default
}

resource "aws_elasticache_user" "this_user" {
  for_each      = local.create_user_map
  access_string = each.value.access_string
  engine        = each.value.engine
  lifecycle {
    ignore_changes = [
      authentication_mode, # Follows the passwords
      passwords,           # The initial password; the rotation tool owns passwords after creation
    ]
  }
  # Valkey users always need a password; the off default user gets one nobody holds
  passwords = [each.value.is_default ? random_password.default_user[each.value.group_key].result : jsondecode(module.secret.secret_map[each.value.secret_key])["password"]]
  region    = var.std_map.aws_region_name
  tags      = each.value.tags
  user_id   = each.value.name_effective
  user_name = each.value.user_name
}

resource "aws_elasticache_user_group" "this_group" {
  for_each      = local.lx_map
  engine        = each.value.engine
  region        = var.std_map.aws_region_name
  tags          = each.value.tags
  user_group_id = each.value.name_effective
  user_ids = [
    for k, v in local.create_user_map : aws_elasticache_user.this_user[k].user_id if v.group_key == each.key
  ]
}
