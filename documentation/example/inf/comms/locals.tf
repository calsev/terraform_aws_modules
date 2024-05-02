locals {
  output_data = merge(module.mobile_analytics_iam.data, {
    ses_config_map = module.ses_config.data
    ses_domain_map = module.ses_domain.data
    ses_email_map  = module.ses_email.data
  })
  std_var = {
    app             = "inf-comms"
    aws_region_name = "us-west-2"
    env             = "prod"
  }
}
