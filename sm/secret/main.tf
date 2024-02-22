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
  source     = "../../secret/init_value"
  secret_map = local.create_init_value_map
}

resource "aws_secretsmanager_secret_version" "initial_value" {
  for_each      = local.create_init_value_map
  secret_id     = aws_secretsmanager_secret.this_secret[each.key].id
  secret_string = module.initial_value.secret_map[each.key]
}
