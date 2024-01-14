resource "aws_apigatewayv2_route" "this_route" {
  for_each                   = local.lx_map
  api_id                     = each.value.api_id
  api_key_required           = null # WS
  authorization_scopes       = each.value.authorization_scopes
  authorization_type         = each.value.authorization_type
  authorizer_id              = each.value.authorizer_id
  model_selection_expression = null # TODO
  operation_name             = each.value.operation_name
  request_models             = {} # TODO
  # request_parameter WS
  route_key                           = each.value.k_route
  route_response_selection_expression = null # WS
  target                              = each.value.integration_id
}
