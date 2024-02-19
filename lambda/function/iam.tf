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

module "role_policy_map" {
  source = "../../iam/role/policy_map"
  role_map = {
    for k, v in local.lx_map : k => merge(v, {
      embedded_role_policy_attach_arn_map = {
        ecr_image_read = {
          condition = v.source_is_image
          policy    = v.iam_policy_arn_source_image_read
        }
        queue_dead_letter_write = {
          condition = v.dead_letter_queue_enabled
          policy    = v.dead_letter_queue_enabled ? module.dead_letter_queue.data[k].iam_policy_arn_map["write"] : null
        }
        vpc_networking = {
          condition = v.vpc_key != null
          policy    = var.iam_data.iam_policy_arn_lambda_vpc
        }
      }
      embedded_role_policy_inline_json_map = {
        log_write = {
          condition = true
          policy    = jsonencode(module.log_group.data[k].iam_policy_doc_map["write"])
        }
      }
    })
  }
  role_policy_attach_arn_map_default   = var.role_policy_attach_arn_map_default
  role_policy_create_json_map_default  = var.role_policy_create_json_map_default
  role_policy_inline_json_map_default  = var.role_policy_inline_json_map_default
  role_policy_managed_name_map_default = var.role_policy_managed_name_map_default
}

module "function_role" {
  source                   = "../../iam/role/base"
  for_each                 = local.lx_map
  assume_role_service_list = ["lambda"]
  name                     = "lambda-${each.key}"
  policy_attach_arn_map    = module.role_policy_map.data[each.key].role_policy_attach_arn_map
  policy_create_json_map   = module.role_policy_map.data[each.key].role_policy_create_json_map
  policy_inline_json_map   = module.role_policy_map.data[each.key].role_policy_inline_json_map
  policy_managed_name_map  = module.role_policy_map.data[each.key].role_policy_managed_name_map
  std_map                  = var.std_map
}