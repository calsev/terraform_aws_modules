{{ iam.policy_identity_ar_type(policy_name="function_policy", suffix="lambda/function") }}

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
      policy    = each.value.dead_letter_queue_enabled ? module.dead_letter_queue.data[each.key].policy_map["write"].iam_policy_arn : null
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
  {{ iam.role_map_item() }}
  std_map                              = var.std_map
}
