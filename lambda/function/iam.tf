module "function_policy" {
  source                          = "../../iam/policy/identity/lambda/function"
  name_append_default             = var.name_append_default
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_prefix_default             = var.name_prefix_default
  name_prepend_default            = var.name_prepend_default
  name_suffix_default             = var.name_suffix_default
  policy_access_list_default      = var.policy_access_list_default
  policy_create_default           = var.policy_create_default
  policy_map                      = local.create_policy_map
  policy_name_append_default      = var.policy_name_append_default
  policy_name_prefix_default      = var.policy_name_prefix_default
  std_map                         = var.std_map
}

module "function_role" {
  source                   = "../../iam/role/base"
  for_each                 = local.lx_map
  assume_role_service_list = ["lambda"]
  embedded_role_policy_attach_arn_map = {
    ecr_image_read = {
      condition = each.value.source_is_image
      policy    = each.value.iam_policy_arn_source_image_read
    }
    queue_dead_letter_write = {
      condition = each.value.dead_letter_queue_enabled
      policy    = each.value.dead_letter_queue_enabled ? module.dead_letter_queue.data[each.key].policy_map["push"].iam_policy_arn : null
    }
    vpc_networking = {
      condition = each.value.vpc_key != null
      policy    = var.iam_data.iam_policy_arn_lambda_vpc
    }
  }
  embedded_role_policy_inline_json_map = {
    log_write = {
      condition = true
      policy    = jsonencode(module.log_group.data[each.key].policy_map["write"].iam_policy_doc)
    }
  }
  map_policy                           = each.value
  name                                 = "lambda_${each.key}"
  role_policy_attach_arn_map_default   = var.role_policy_attach_arn_map_default
  role_policy_create_json_map_default  = var.role_policy_create_json_map_default
  role_policy_inline_json_map_default  = var.role_policy_inline_json_map_default
  role_policy_managed_name_map_default = var.role_policy_managed_name_map_default
  role_path_default                    = var.role_path_default
  std_map                              = var.std_map
}
