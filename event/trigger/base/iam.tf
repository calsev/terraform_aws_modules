module "role_policy_map" {
  source = "../../../iam/role/policy_map"
  role_map = {
    for k, v in local.role_map : k => merge(v, {
      embedded_role_policy_attach_arn_map = {
        batch_submit_job = {
          condition = length(v.batch_targets) > 0
          policy    = var.iam_data.iam_policy_arn_batch_submit_job
        }
        ecs_start_task = {
          condition = length(v.ecs_targets) > 0
          policy    = var.iam_data.iam_policy_arn_ecs_start_task
        }
        queue_dead_letter_write = {
          condition = v.dead_letter_queue_enabled
          policy    = v.dead_letter_queue_enabled ? module.dead_letter_queue.data[k].iam_policy_arn_map.write : null
        }
      }
    })
  }
  role_policy_attach_arn_map_default   = var.role_policy_attach_arn_map_default
  role_policy_create_json_map_default  = var.role_policy_create_json_map_default
  role_policy_inline_json_map_default  = var.role_policy_inline_json_map_default
  role_policy_managed_name_map_default = var.role_policy_managed_name_map_default
}

module "trigger_role" {
  source                   = "../../../iam/role/base"
  for_each                 = local.role_map
  assume_role_service_list = ["events"]
  name                     = "trigger-${each.key}"
  policy_attach_arn_map    = module.role_policy_map.data[each.key].role_policy_attach_arn_map
  policy_create_json_map   = module.role_policy_map.data[each.key].role_policy_create_json_map
  policy_inline_json_map   = module.role_policy_map.data[each.key].role_policy_inline_json_map
  policy_managed_name_map  = module.role_policy_map.data[each.key].role_policy_managed_name_map
  std_map                  = var.std_map
}
