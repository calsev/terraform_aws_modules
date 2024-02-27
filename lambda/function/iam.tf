module "function_policy" {
  source        = "../../iam/policy/identity/lambda/function"
  for_each      = local.lx_map
  name          = each.value.policy_name
  name_infix    = each.value.policy_name_infix
  name_prefix   = each.value.policy_name_prefix
  access_list   = each.value.policy_access_list
  function_name = each.value.name_effective
  std_map       = var.std_map
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
      policy    = each.value.dead_letter_queue_enabled ? module.dead_letter_queue.data[each.key].iam_policy_arn_map["write"] : null
    }
    vpc_networking = {
      condition = each.value.vpc_key != null
      policy    = var.iam_data.iam_policy_arn_lambda_vpc
    }
  }
  embedded_role_policy_inline_json_map = {
    log_write = {
      condition = true
      policy    = jsonencode(module.log_group.data[each.key].iam_policy_doc_map["write"])
    }
  }
  map_policy                           = each.value
  name                                 = "lambda-${each.key}"
  role_policy_attach_arn_map_default   = var.role_policy_attach_arn_map_default
  role_policy_create_json_map_default  = var.role_policy_create_json_map_default
  role_policy_inline_json_map_default  = var.role_policy_inline_json_map_default
  role_policy_managed_name_map_default = var.role_policy_managed_name_map_default
  std_map                              = var.std_map
}
