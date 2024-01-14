module "queue_policy" {
  source      = "../../iam/policy/identity/sqs_queue"
  for_each    = local.queue_map
  name        = each.value.policy_name
  name_infix  = each.value.policy_name_infix
  name_prefix = each.value.policy_name_prefix
  access_list = each.value.policy_access_list
  queue_name  = each.value.name_effective
  std_map     = var.std_map
}
