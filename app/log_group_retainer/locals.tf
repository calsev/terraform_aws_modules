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
      role_policy_attach_arn_map = {
        reserved_instance_purchaser = module.retainer_policy.data[local.policy_key].iam_policy_arn
      }
      source_content_path_of_file_to_create_in_archive = "ensure_log_group_retention.py"
      source_package_created_archive_path              = "${path.root}/config/${k}.zip"
      source_content_string = templatefile("${path.module}/app/ensure_log_group_retention.py", {
        metric_default_days    = v.metric_default_days
        metric_max_days        = v.metric_max_days
        metric_min_days        = v.metric_min_days
        retention_default_days = v.retention_default_days
        retention_max_days     = v.retention_max_days
        retention_min_days     = v.retention_min_days
      })
    })
  }
  create_trigger_1_list = flatten([
    for k, v in local.lx_map : [
      merge(v, {
        k_all = "${k}_schedule"
        role_policy_attach_arn_map = {
          invoke_lambda = module.lambda.data[k].policy_map["write"].iam_policy_arn
        }
        schedule_expression = var.event_schedule_expression_default
        target_arn          = module.lambda.data[k].lambda_arn
      }),
      merge(v, {
        k_all = "${k}_creation"
        event_pattern_json = jsonencode({
          detail = {
            eventName   = ["CreateLogGroup"]
            eventSource = ["logs.amazonaws.com"]
          }
          detail-type = ["AWS API Call via CloudTrail"]
          source      = ["aws.logs"]
        })
        target_arn = module.lambda.data[k].lambda_arn
      }),
    ]
  ])
  create_trigger_x_map = {
    for v in local.create_trigger_1_list : v.k_all => v
  }
  l0_map = {
    log_retainer = {}
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      metric_default_days    = var.metric_default_days
      metric_max_days        = var.metric_max_days
      metric_min_days        = var.metric_min_days
      retention_default_days = var.retention_default_days
      retention_max_days     = var.retention_max_days
      retention_min_days     = var.retention_min_days
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
        for k_attr, v_attr in v : k_attr => v_attr if !contains(["source_content_string"], k_attr)
      },
      {
        lambda = module.lambda.data[k]
        policy = module.retainer_policy.data
        trigger = {
          for k_trig in ["creation", "schedule"] : "${k}_${k_trig}" => module.trigger.data["${k}_${k_trig}"]
        }
      }
    )
  }
  policy_key = "logs_retention_setter"
}
