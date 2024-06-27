locals {
  output_data = merge(
    module.cw_config_ecs.data,
    module.ecs_dashboard.data,
    {
      alert  = module.alert_account.data
      api    = module.api_account.data
      config = module.config_account.data
      event  = module.event_account.data
      sms    = module.sms_account.data
      trail  = module.cloudtrail.data
    },
  )
  std_var = {
    app             = "inf-mon"
    aws_region_name = "us-west-2"
    env             = "prod"
  }
}
