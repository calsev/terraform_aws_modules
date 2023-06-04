module "queue_policy" {
  source      = "../iam_policy_identity_sqs_queue"
  for_each    = local.queue_map
  access_list = ["write"]
  queue_name  = module.dead_letter_queue.data[each.key].name
  std_map     = var.std_map
}

module "trigger_role" {
  source                   = "../iam_role"
  for_each                 = local.role_map
  assume_role_service_list = ["events"]
  name                     = "trigger-${each.key}"
  policy_attach_arn_map = merge(
    length(each.value.batch_targets) == 0 ? {} : {
      batch_submit_job = var.iam_data.iam_policy_arn_batch_submit_job
    },
    length(each.value.ecs_targets) == 0 ? {} : {
      ecs_start_task = var.iam_data.iam_policy_arn_ecs_start_task
    },
    each.value.iam_policy_arn_target == null ? {} : {
      "${each.value.target_service}_write" = each.value.iam_policy_arn_target
    }
  )
  policy_inline_json_map = merge(
    !each.value.dead_letter_queue_enabled ? {} : {
      queue_dead_letter = jsonencode(module.queue_policy[each.value.dead_letter_queue_name].data.iam_policy_doc_map.write)
    },
  )
  std_map = var.std_map
}
