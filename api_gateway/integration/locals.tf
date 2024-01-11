locals {
  i1_list = flatten([
    for k_api, v_api in var.api_map : [
      for k, v in v_api.integration_map : merge(
        {
          for k, v in v_api : k => v if !contains(["integration_map"], k)
        },
        v,
        {
          iam_role_arn         = v.iam_role_arn == null ? v_api.integration_iam_role_arn_default == null ? var.integration_iam_role_arn_default : v_api.integration_iam_role_arn_default : v.iam_role_arn
          k_api                = k_api
          k_int                = k
          passthrough_behavior = v.passthrough_behavior == null ? var.integration_passthrough_behavior_default : v.passthrough_behavior
          service              = v.service == null ? var.integration_service_default : v.service
          timeout_seconds      = v.timeout_seconds == null ? var.integration_timeout_seconds_default : v.timeout_seconds
          vpc_link_id          = v.vpc_link_id == null ? var.integration_vpc_link_id_default : v.vpc_link_id
        },
      )
    ]
  ])
  i2_list = [
    for v in local.i1_list : merge(v, {
      request_parameters = v.request_parameters != null ? v.request_parameters : v.service == "sqs" ? {
        MessageBody            = "$request.body"
        MessageDeduplicationId = "$context.requestId"
        MessageGroupId         = "$context.requestId"
        QueueUrl               = v.target_uri
        Region                 = var.std_map.aws_region_name
        } : v.service == "states" ? {
        Input = "$request.body"
        #Name            = replace("${k_api}-${k_int}", var.std_map.name_replace_regex, "-")
        Region          = var.std_map.aws_region_name
        StateMachineArn = v.target_arn
        } : {
        # TODO: Other services
      }
      subtype = v.subtype == null ? lookup(var.integration_subtype_map_default, v.service, null) : v.subtype
    })
  ]
  integration_list = [
    for v in local.i2_list : merge(v, {
      http_method = v.subtype == null ? v.http_method == null ? var.integration_http_method_default : v.http_method : null
      target_uri  = v.subtype == null ? v.target_uri : null
    })
  ]
  integration_map = {
    for integration in local.integration_list : "${integration.k_api}-${integration.k_int}" => integration
  }
  output_data = {
    for k_api, v_api in var.api_map : k_api => {
      for k_int, _ in v_api.integration_map : k_int => merge(
        {
          for k, v in local.integration_map["${k_api}-${k_int}"] : k => v if !contains(["k_api", "k_int"], k)
        },
        {
          id = aws_apigatewayv2_integration.this_integration["${k_api}-${k_int}"].id
        },
      )
    }
  }
}
