resource "aws_lambda_layer_version_permission" "this_permission" {
  for_each        = local.create_permission_x_map
  action          = "lambda:GetLayerVersion"
  layer_name      = each.value.layer_arn
  organization_id = null # Not supported, grants are per account
  principal       = each.value.aws_account_id
  region          = var.std_map.aws_region_name
  skip_destroy    = each.value.skip_destroy
  statement_id    = "account-${each.value.aws_account_id}"
  version_number  = each.value.version_number
}
