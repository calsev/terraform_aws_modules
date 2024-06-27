provider "aws" {
  region = local.std_var.aws_region_name
}

module "com_lib" {
  source  = "path/to/modules/common"
  std_var = local.std_var
}

module "config_account" {
  source                       = "path/to/modules/config/aws_account"
  record_retention_period_days = 30
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
  source = "path/to/modules/sns/alert_aws_account"
  email_list = [
    "example@example.com",
  ]
  std_map = module.com_lib.std_map
}

module "cloudtrail" {
  source                       = "path/to/modules/cloudtrail/trail"
  s3_data_map                  = data.terraform_remote_state.s3.outputs.data.bucket[local.std_var.aws_region_name]
  std_map                      = module.com_lib.std_map
  trail_log_bucket_key_default = "example_log"
  trail_map = {
    management_event = {
      advanced_event_selector_map = {
        "Management event selector" = {
          management_category_selector = {
            equal_list = ["Management"]
            field      = "eventCategory"
          }
        }
      }
    }
  }
}

module "local_config" {
  source  = "path/to/modules/local_config"
  content = local.output_data
  std_map = module.com_lib.std_map
}
