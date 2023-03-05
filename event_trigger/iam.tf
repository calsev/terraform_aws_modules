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
  attach_policy_arn_map = length(each.value.batch_targets) > 0 ? {
    batch_submit_job = var.iam_data.iam_policy_arn_batch_submit_job
    } : {
    ecs_start_task = var.iam_data.iam_policy_arn_ecs_start_task
  }
  inline_policy_json_map = each.value.dead_letter_queue_enabled ? {
    queue_dead_letter = jsonencode(module.queue_policy[each.value.dead_letter_queue_name].data.iam_policy_doc_map.write)
  } : null
  name    = "trigger-${each.key}"
  std_map = var.std_map
}
