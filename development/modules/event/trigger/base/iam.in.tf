module "trigger_role" {
  source                   = "../../../iam/role/base"
  for_each                 = local.create_role_map
  assume_role_service_list = ["events"]
  embedded_role_policy_attach_arn_map = {
    batch_submit_job = {
      condition = length(each.value.batch_targets) > 0
      policy    = var.iam_data.iam_policy_arn_batch_submit_job
    }
    ecs_start_task = {
      condition = length(each.value.ecs_targets) > 0
      policy    = var.iam_data.iam_policy_arn_ecs_start_task
    }
    queue_dead_letter_write = {
      condition = each.value.dead_letter_queue_enabled
      policy    = each.value.dead_letter_queue_enabled ? module.dead_letter_queue.data[each.key].policy_map["write"].iam_policy_arn : null
    }
  }
  map_policy                           = each.value
  name                                 = "trigger_${each.key}"
  {{ iam.role_map_item() }}
  std_map                              = var.std_map
}
