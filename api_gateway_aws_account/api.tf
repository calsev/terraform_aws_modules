module "api_log_role" {
  source                   = "../iam_role"
  assume_role_service_list = ["apigateway"]
  managed_policy_name_map = {
    api_logging = "service-role/AmazonAPIGatewayPushToCloudWatchLogs"
  }
  name    = "api-log"
  std_map = var.std_map
}

resource "aws_api_gateway_account" "this_api_account" {
  cloudwatch_role_arn = module.api_log_role.data.iam_role_arn
}
