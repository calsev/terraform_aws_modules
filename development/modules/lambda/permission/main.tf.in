resource "aws_lambda_permission" "this_permission" {
  for_each               = local.create_permission_map
  action                 = each.value.action
  event_source_token     = null # Alexa
  function_name          = each.value.name
  function_url_auth_type = each.value.function_url_auth_type
  principal              = each.value.principal
  principal_org_id       = null # TODO
  qualifier              = each.value.qualifier
  source_account         = var.std_map.aws_account_id
  source_arn             = each.value.source_arn
  statement_id           = each.value.name_effective
}
