resource "aws_apigatewayv2_route" "this_route" {
  for_each             = local.route_map
  api_id               = each.value.api_id
  authorization_scopes = each.value.authorization_scopes
  authorization_type   = each.value.authorization_type
  authorizer_id        = each.value.authorizer_id
  operation_name       = each.value.operation_name
  request_models       = {}
  route_key            = each.value.k_route
  target               = each.value.integration_id
}
