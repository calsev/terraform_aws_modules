locals {
  log_format_list = [
    "accountId",
    "apiId",
    #"authenticate.error",
    #"authenticate.latency",
    #"authenticate.status",
    #"authorize.error",
    #"authorize.latency",
    #"authorize.status",
    "authorizer.error",
    "authorizer.integrationLatency",
    "authorizer.integrationStatus",
    "authorizer.latency",
    "authorizer.principalId",
    "authorizer.requestId",
    "authorizer.status",
    "awsEndpointRequestId",
    "customDomain.basePathMatched",
    "domainName",
    "domainPrefix",
    "error.message",
    "error.responseType",
    #"error.validationErrorString",
    "extendedRequestId",
    "httpMethod",
    "identity.accountId",
    #"identity.apiKey",
    #"identity.apiKeyId",
    "identity.caller",
    "identity.cognitoAuthenticationProvider",
    "identity.cognitoAuthenticationType",
    "identity.cognitoIdentityId",
    "identity.cognitoIdentityPoolId",
    "identity.principalOrgId",
    "identity.sourceIp",
    "identity.user",
    "identity.userAgent",
    "identity.userArn",
    "integration.error",
    "integration.integrationStatus",
    "integration.latency",
    "integration.requestId",
    "integration.status",
    "integrationErrorMessage",
    "integrationLatency",
    "integrationStatus",
    "path",
    "protocol",
    "requestId",
    "requestTime",
    #"resourceId",
    "resourcePath",
    "responseLatency",
    "responseLength",
    #"responseOverride.status",
    "stage",
    "status",
    #"waf.error",
    #"waf.latency",
    #"waf.status",
    #"wafResponseCode",
    #"webaclArn",
    #"xrayTraceId",
  ]
  log_format_map = {
    for v in local.log_format_list : v => "$context.${v}"
  }
  mapping_map = {
    for k_api, v_api in local.stage_map : k_api => v_api if v_api.domain_name_id != null
  }
  route_list = {
    for k_api, v_api in var.api_map : k_api => flatten([
      for k_int, v_int in v_api.integration_map : [
        for k_route, v_route in v_int.route_map : merge(v_route, {
          k_route = k_route # These have to be unique per API
        })
      ]
    ])
  }
  route_map = {
    for k_api, v_api in local.route_list : k_api => {
      for v_route in v_api : v_route.k_route => {
        for k, v in v_route : k => v if !contains(["k_route"], k)
      }
    }
  }
  stage_list = flatten([
    for k_api, v_api in var.api_map : [
      for k_stage, v_stage in v_api.stage_map : merge(
        { for k, v in v_api : k => v if !contains(["integration_map", "stage_map"], k) },
        v_stage,
        {
          detailed_metrics_enabled = v_stage.detailed_metrics_enabled == null ? var.stage_detailed_metrics_enabled_default : v_stage.detailed_metrics_enabled
          enable_default_route     = v_stage.enable_default_route == null ? var.stage_enable_default_route_default : v_stage.enable_default_route
          k_api                    = k_api
          k_stage                  = k_stage
          name                     = replace("${k_api}-${k_stage}", "/[_.]/", "-")
          route_map                = local.route_map[k_api]
          tags = merge(
            var.std_map.tags,
            {
              Name = "${var.std_map.resource_name_prefix}${replace("${k_api}-${k_stage}", "/[_]/", "-")}${var.std_map.resource_name_suffix}"
            }
          )
          throttling_burst_limit = v_stage.throttling_burst_limit == null ? var.stage_throttling_burst_limit_default : v_stage.throttling_burst_limit
          throttling_rate_limit  = v_stage.throttling_rate_limit == null ? var.stage_throttling_rate_limit_default : v_stage.throttling_rate_limit
        },
      )
    ]
  ])
  stage_map = {
    for stage in local.stage_list : "${stage.k_api}-${stage.k_stage}" => stage
  }
  output_data = {
    for k_api, v_api in var.api_map : k_api => {
      for k_stage, _ in v_api.stage_map : k_stage => merge(
        {
          for k, v in local.stage_map["${k_api}-${k_stage}"] : k => v if !contains(["k_api", "k_stage"], k)
        },
        {
          id = aws_apigatewayv2_stage.this_stage["${k_api}-${k_stage}"].id
        },
      )
    }
  }
}
