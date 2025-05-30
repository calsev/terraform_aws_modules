module "api_log_role" {
  source                   = "../../iam/role/base"
  assume_role_service_list = ["apigateway"]
  name                     = "api_log"
  role_policy_managed_name_map_default = {
    api_logging = "service-role/AmazonAPIGatewayPushToCloudWatchLogs"
  }
  std_map = var.std_map
}

resource "aws_api_gateway_account" "this_api_account" {
  cloudwatch_role_arn = module.api_log_role.data.iam_role_arn
}
