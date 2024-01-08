locals {
  output_data = {
    lambda = module.lambda.data
  }
  std_var = {
    app             = "app-lambda"
    aws_region_name = "us-west-2"
    env             = "prod"
  }
}
