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
        reserved_instance_purchaser = module.purchaser_policy.data[local.policy_key].iam_policy_arn
      }
      source_content_path_of_file_to_create_in_archive = "purchase_reserved_instance.py"
      source_package_created_archive_path              = "${path.root}/config/purchase_reserved_instance_${k}.zip"
      source_content_string = templatefile("${path.module}/app/purchase_reserved_instance.py", {
        dry_run                 = v.dry_run
        email_recipient         = v.email_recipient
        email_sender            = v.email_sender
        instance_platform       = v.instance_platform
        instance_tenancy        = v.instance_tenancy
        instance_type           = v.instance_type
        max_total_instances     = v.max_total_instances
        offer_max_duration_days = v.offer_max_duration_days
        offer_max_hourly_price  = v.offer_max_hourly_price
      })
    })
  }
  create_lambda_permission_map = {
    for k, v in local.lx_map : k => merge(v, {
      lambda_arn = module.lambda.data[k].lambda_arn
      source_arn = module.trigger.data[k].event_rule_arn
    })
  }
  create_trigger_map = {
    for k, v in local.lx_map : k => merge(v, {
      target_arn = module.lambda.data[k].lambda_arn
    })
  }
  l0_map = {
    for k, v in var.purchaser_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      dry_run                 = v.dry_run == null ? var.purchaser_dry_run_default : v.dry_run
      email_recipient         = v.email_recipient == null ? var.purchaser_email_recipient_default : v.email_recipient
      email_sender            = v.email_sender == null ? var.purchaser_email_sender_default : v.email_sender
      instance_platform       = v.instance_platform == null ? var.purchaser_instance_platform_default : v.instance_platform
      instance_tenancy        = v.instance_tenancy == null ? var.purchaser_instance_tenancy_default : v.instance_tenancy
      instance_type           = v.instance_type == null ? var.purchaser_instance_type_default == null ? k : var.purchaser_instance_type_default : v.instance_type
      max_total_instances     = v.max_total_instances == null ? var.purchaser_max_total_instances_default : v.max_total_instances
      offer_max_duration_days = v.offer_max_duration_days == null ? var.purchaser_offer_max_duration_days_default : v.offer_max_duration_days
      offer_max_hourly_price  = v.offer_max_hourly_price == null ? var.purchaser_offer_max_hourly_price_default : v.offer_max_hourly_price
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
        lambda            = module.lambda.data[k]
        lambda_permission = module.lambda_permission.data[k]
        trigger           = module.trigger.data[k]
      }
    )
  }
  policy_key = "ec2_reserved_instance_purchaser"
}
