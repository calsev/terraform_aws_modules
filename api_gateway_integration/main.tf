resource "aws_apigatewayv2_integration" "this_integration" {
  for_each            = local.integration_map
  api_id              = each.value.api_id
  connection_id       = each.value.vpc_link_id
  connection_type     = each.value.vpc_link_id == null ? "INTERNET" : "VPC_LINK"
  credentials_arn     = each.value.iam_role_arn
  integration_method  = each.value.http_method
  integration_subtype = local.subtype_map[each.value.subtype]
  integration_type    = "AWS_PROXY"
  #payload_format_version # This defaults to the latest for the integration, and errors if the version is not supported
  request_parameters = each.value.request_parameters
  #response_parameters
  timeout_milliseconds = each.value.timeout_seconds == null ? null : each.value.timeout_seconds * 1000
  #tls_config
}
