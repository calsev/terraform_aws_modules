resource "aws_secretsmanager_secret" "this_secret" {
  for_each                       = local.lx_map
  force_overwrite_replica_secret = each.value.force_overwrite
  kms_key_id                     = each.value.kms_key_id
  name                           = each.value.name_effective
  policy                         = each.value.resource_policy_json
  recovery_window_in_days        = each.value.recovery_window_days
  # replica # TODO
  tags = each.value.tags
}

module "initial_value" {
  source                                      = "../../secret/init_value"
  secret_map                                  = local.create_init_value_map
  secret_random_special_character_set_default = var.secret_random_special_character_set_default
}

resource "aws_secretsmanager_secret_version" "initial_value" {
  for_each = local.create_init_value_map
  lifecycle {
    ignore_changes = [
      secret_string, # This is the initial value; rotate externally after
    ]
  }
  secret_id     = aws_secretsmanager_secret.this_secret[each.key].id
  secret_string = module.initial_value.secret_map[each.key]
}
