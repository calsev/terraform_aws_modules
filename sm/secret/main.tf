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
  source     = "../../random/password"
  random_map = local.init_value_map
  std_map    = var.std_map
}

resource "aws_secretsmanager_secret_version" "initial_value" {
  for_each  = local.init_value_map
  secret_id = aws_secretsmanager_secret.this_secret[each.key].id
  secret_string = each.value.secret_random_init_map_final == null ? module.initial_value.secret_map[each.key] : jsonencode(merge(
    each.value.secret_random_init_map_final,
    {
      (each.value.secret_random_init_key) = module.initial_value.secret_map[each.key]
    }
  ))
}
