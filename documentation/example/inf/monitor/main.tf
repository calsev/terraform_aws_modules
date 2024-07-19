provider "aws" {
  region = local.std_var.aws_region_name
}

module "com_lib" {
  source  = "path/to/modules/common"
  std_var = local.std_var
}

module "budget" {
  source = "path/to/modules/budget/budget"
  budget_map = {
    account = {
      limit_amount = 100
    }
  }
  budget_notification_subscriber_email_address_list_default = ["example@example.com"]
  std_map                                                   = module.com_lib.std_map
}

module "config_account" {
  source                       = "path/to/modules/config/aws_account"
  record_retention_period_days = 30
  s3_bucket_key                = "example_log"
  s3_data_map                  = data.terraform_remote_state.s3.outputs.data.bucket[local.std_var.aws_region_name]
  std_map                      = module.com_lib.std_map
}

module "sms_account" {
  source                                = "path/to/modules/sms/aws_account"
  default_sender_id_string              = "The Company"
  delivery_status_success_sampling_rate = 0
  monthly_spend_limit                   = 1
}

module "api_account" {
  source  = "path/to/modules/api_gateway/aws_account"
  std_map = module.com_lib.std_map
}

module "cw_config_ecs" {
  source  = "path/to/modules/cw/config_ecs"
  std_map = module.com_lib.std_map
}

module "ecs_dashboard" {
  source  = "path/to/modules/ecs/dashboard"
  std_map = module.com_lib.std_map
}

module "event_account" {
  source  = "path/to/modules/event/aws_account"
  std_map = module.com_lib.std_map
}

module "alert_account" {
  source = "path/to/modules/app/alert_aws_account"
  alert_email_address_list_default = [
    "example@example.com",
  ]
  encrypt_trail_with_kms = false
  s3_data_map            = data.terraform_remote_state.s3.outputs.data.bucket[local.std_var.aws_region_name]
  std_map                = module.com_lib.std_map
  trail_log_bucket_key   = "example_log"
}

module "athena_workgroup" {
  source = "path/to/modules/athena/workgroup"
  group_map = {
    primary = {
      # This must be imported
      name_infix = false
    }
  }
  std_map = module.com_lib.std_map
}

module "local_config" {
  source  = "path/to/modules/local_config"
  content = local.output_data
  std_map = module.com_lib.std_map
}
