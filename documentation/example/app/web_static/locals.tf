locals {
  output_data = module.web_app.data
  std_var = {
    app             = "app-web-static"
    aws_region_name = "us-west-2"
    env             = "prod"
  }
}
