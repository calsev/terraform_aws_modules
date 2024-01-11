resource "aws_apigatewayv2_integration" "this_integration" {
  for_each                  = local.integration_map
  api_id                    = each.value.api_id
  connection_id             = each.value.vpc_link_id
  connection_type           = each.value.vpc_link_id == null ? "INTERNET" : "VPC_LINK"
  content_handling_strategy = null # WS
  credentials_arn           = each.value.iam_role_arn
  integration_method        = each.value.http_method
  integration_subtype       = each.value.subtype
  integration_type          = "AWS_PROXY"
  integration_uri           = each.value.target_uri
  passthrough_behavior      = each.value.passthrough_behavior
  payload_format_version    = null # This defaults to the latest for the integration, and errors if the version is not supported
  request_parameters        = each.value.request_parameters
  request_templates         = {} # WS
  # response_parameters {
  #   mappings    = {} # TODO
  #   status_code = 200
  # }
  template_selection_expression = null # TODO
  timeout_milliseconds          = each.value.timeout_seconds == null ? null : each.value.timeout_seconds * 1000
  # tls_config {
  #   server_name_to_verify = null # TODO
  # }
}
