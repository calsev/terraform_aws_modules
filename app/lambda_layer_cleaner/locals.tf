module "name_map" {
  source                          = "../../name_map"
  name_append_default             = var.name_append_default
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_map                        = local.l0_map
  name_prefix_default             = var.name_prefix_default
  name_prepend_default            = var.name_prepend_default
  name_regex_allow_list           = var.name_regex_allow_list
  name_suffix_default             = var.name_suffix_default
  std_map                         = var.std_map
}

locals {
  create_lambda_map = {
    for k, v in local.lx_map : k => merge(v, {
      environment_variable_map = {
        ACCOUNT_ID                     = var.std_map.aws_account_id
        DRY_RUN                        = v.dry_run ? "true" : "false"
        EXCLUDED_LAYER_ARN_LIST        = jsonencode(v.excluded_layer_arn_list)
        MANAGED_LAYER_VERSION_ARN_LIST = jsonencode(v.managed_layer_version_arn_list)
      }
      role_policy_attach_arn_map = {
        layer_cleaner = module.cleaner_policy.data[local.policy_key].iam_policy_arn
      }
      source_content_local_path           = "${path.module}/app/clean_lambda_layers.py"
      source_package_created_archive_path = "${path.root}/config/${v.name_simple}${var.std_map.resource_name_suffix}.zip"
    })
  }
  create_trigger_x_map = {
    for k, v in local.lx_map : "${k}_schedule" => merge(v, {
      role_policy_attach_arn_map = {
        invoke_lambda = module.lambda.data[k].policy_map["write"].iam_policy_arn
      }
      schedule_expression = var.event_schedule_expression_default
      target_arn          = module.lambda.data[k].lambda_arn
    })
  }
  l0_map = {
    layer_cleaner = {}
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      dry_run                        = var.dry_run
      excluded_layer_arn_list        = sort(distinct(var.excluded_layer_arn_list))
      managed_layer_version_arn_list = sort(distinct(var.managed_layer_version_arn_list))
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
    }
  }
  lx_map = {
    for k, _ in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k])
  }
  output_data = {
    for k, v in local.lx_map : k => merge(
      {
        for k_attr, v_attr in v : k_attr => v_attr if !contains([], k_attr)
      },
      {
        lambda  = module.lambda.data[k]
        policy  = module.cleaner_policy.data
        trigger = module.trigger.data["${k}_schedule"]
      }
    )
  }
  policy_key = "lambda_layer_cleaner"
}
