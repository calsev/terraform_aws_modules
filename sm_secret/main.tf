resource "aws_secretsmanager_secret" "this_secret" {
  for_each                       = local.secret_map
  force_overwrite_replica_secret = each.value.force_overwrite
  kms_key_id                     = each.value.kms_key_id
  name                           = each.value.name_effective
  policy                         = each.value.resource_policy_json
  recovery_window_in_days        = each.value.recovery_window_days
  # replica # TODO
  tags = each.value.tags
}
