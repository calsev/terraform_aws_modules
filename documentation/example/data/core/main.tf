provider "aws" {
  region = local.aws_region_name
}

module "com_lib" {
  source   = "path/to/modules/common"
  for_each = local.std_var_map
  std_var  = each.value
}

module "db_sub" {
  source   = "path/to/modules/rds/subnet_group"
  for_each = local.env_list_instance
  group_map = {
    default = {
      vpc_key = "main"
    }
  }
  std_map      = module.com_lib[each.key].std_map
  vpc_data_map = data.terraform_remote_state.net.outputs.data.vpc_map # Could use separate VPCs
}

module "db" {
  source                     = "path/to/modules/rds/instance"
  for_each                   = local.env_list_instance
  db_create_instance_default = false
  db_map = {
    dev = {
      (local.db_key) = {
        backup_retention_period_day = 0
        delete_automated_backups    = true
        deletion_protection         = false
        final_snapshot_enabled      = false
      }
    }
    prd = {
      (local.db_key) = {
        backup_retention_period_day = 14
        multi_az                    = false # We will spin up a read replica instead
      }
    }
  }[each.key]
  db_engine_default           = "postgres"
  db_engine_version_default   = "16.1"
  db_initial_name_default     = "example_db"
  db_secret_is_param_default  = false # Not supported for proxy
  db_subnet_group_key_default = "default"
  db_username_default         = "example_user"
  iam_data                    = data.terraform_remote_state.iam.outputs.data
  std_map                     = module.com_lib[each.key].std_map
  subnet_group_map            = module.db_sub[each.key].data
  vpc_data_map                = data.terraform_remote_state.net.outputs.data.vpc_map # Could use separate VPCs
}

module "db_proxy" {
  source                                  = "path/to/modules/rds/proxy"
  for_each                                = local.env_list_instance
  db_data_map                             = module.db[each.key].data
  proxy_auth_client_password_type_default = "POSTGRES_SCRAM_SHA_256"
  proxy_create_instance_default           = false
  proxy_engine_family_default             = "POSTGRESQL"
  proxy_map = {
    (local.db_key) = {
      auth_sm_secret_arn = module.db[each.key].data[local.db_key].secret.secret_arn
      iam_role_arn       = module.db_proxy_role[each.key].data.iam_role_arn
      target_group_map = {
        default = {
          target_map = {
            (local.db_key) = {}
          }
        }
      }
    }
  }
  std_map         = module.com_lib[each.key].std_map
  vpc_key_default = "main"
  vpc_data_map    = data.terraform_remote_state.net.outputs.data.vpc_map # Could use separate VPCs
}

module "user_pool" {
  source          = "path/to/modules/cognito/user_pool"
  for_each        = local.env_list_instance
  cdn_global_data = data.terraform_remote_state.cdn_global.outputs.data
  comms_data      = data.terraform_remote_state.comms.outputs.data
  dns_data        = data.terraform_remote_state.dns.outputs.data
  pool_client_app_map_default = {
    app = {
      # No secret, suitable for implicit grant flow on client side (Amplify)
      callback_url_list = [{
        dev = "https://web-dev.example.com"
        prd = "https://web.example.com"
      }[each.key]] # This is never used
    }
    web = {
      # Secret, suitable for authorization code grant flow on server side (ELB)
      callback_url_list = ["https://web.example.com/oauth2/idpresponse"]
      generate_secret   = true
    }
  }
  pool_dns_from_zone_key_default   = "example.com"
  pool_email_from_username_default = "ExampleApp"
  pool_group_map_default = {
    user = {
      precedence = 200
    }
    admin = {
      precedence = 100
    }
  }
  pool_lambda_arn_post_confirmation_default = null # TODO
  pool_map = {
    app = {
      email_ses_key = "noreply@example.com"
    }
  }
  pool_only_admin_create_user_default  = false
  pool_username_attribute_list_default = ["email", ]
  std_map                              = module.com_lib[each.key].std_map
}

module "identity_pool" {
  source                                       = "path/to/modules/cognito/identity_pool"
  for_each                                     = local.env_list_instance
  cognito_data_map                             = module.user_pool[each.key].data
  pool_cognito_provider_client_app_key_default = "app"
  pool_cognito_provider_map_default = {
    app = {}
  }
  pool_map = {
    app_user = {}
  }
  std_map = module.com_lib[each.key].std_map
}

module "local_config" {
  source   = "path/to/modules/local_config"
  for_each = local.std_var_map
  content  = local.output_data_map[each.key]
  std_map  = module.com_lib[each.key].std_map
}
