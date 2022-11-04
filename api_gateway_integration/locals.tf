locals {
  integration_list = flatten([
    for k_api, v_api in var.api_map : [
      for k_int, v_int in v_api.integration_map : merge(
        { for k, v in v_api : k => v if !contains(["integration_map"], k) },
        v_int,
        {
          iam_role_arn = v_int.iam_role_arn == null ? v_api.integration_iam_role_arn_default == null ? var.integration_iam_role_arn_default : v_api.integration_iam_role_arn_default : v_int.iam_role_arn
          http_method  = local.integration_subtype_map[k_api][k_int] == null ? v_int.http_method == null ? var.integration_http_method_default : v_int.http_method : null
          k_api        = k_api
          k_int        = k_int
          request_parameters = local.integration_subtype_map[k_api][k_int] != "step_function" ? {} : {
            Input = "$request.body"
            #Name            = replace("${k_api}-${k_int}", "/[_]/", "-")
            Region          = var.std_map.aws_region_name
            StateMachineArn = v_int.target_arn
          }
          subtype         = local.integration_subtype_map[k_api][k_int]
          target_uri      = local.integration_subtype_map[k_api][k_int] == "step_function" ? local.step_func_target : v_int.target_uri == null ? var.integration_target_uri_default : v_int.target_uri
          timeout_seconds = v_int.timeout_seconds == null ? var.integration_timeout_seconds_default : v_int.timeout_seconds
          vpc_link_id     = v_int.vpc_link_id == null ? var.integration_vpc_link_id_default : v_int.vpc_link_id
        },
      )
    ]
  ])
  integration_map = {
    for integration in local.integration_list : "${integration.k_api}-${integration.k_int}" => integration
  }
  integration_subtype_map = {
    for k_api, v_api in var.api_map : k_api => {
      for k_int, v_int in v_api.integration_map : k_int => v_int.subtype == null ? var.integration_subtype_default : v_int.subtype
    }
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
  step_func_target = "arn:${var.std_map.iam_partition}:apigateway:${var.std_map.aws_region_name}:states:action/StartExecution"
  subtype_map = {
    lambda        = null
    sqs_send      = "SQS-SendMessage"
    step_function = "StepFunctions-StartExecution"
  }
}
