module "this_queue" {
  source    = "../../sqs/queue"
  {{ iam.policy_map_item_ar() }}
  queue_map = local.lx_map
  std_map   = var.std_map
}
