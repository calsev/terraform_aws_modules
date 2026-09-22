resource "aws_cognito_resource_server" "this_server" {
  for_each   = local.lx_map
  identifier = each.value.identifier
  name       = each.value.name_effective
  region     = var.std_map.aws_region_name
  dynamic "scope" {
    for_each = each.value.scope_map
    content {
      scope_description = scope.value
      scope_name        = scope.key
    }
  }
  user_pool_id = each.value.user_pool_id
}
