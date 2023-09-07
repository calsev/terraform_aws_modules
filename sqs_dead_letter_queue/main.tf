module "this_queue" {
  source    = "../sqs_queue"
  queue_map = local.queue_map
  std_map   = var.std_map
}
