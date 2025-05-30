module "this_queue" {
  source                     = "../../sqs/queue"
  policy_access_list_default = var.policy_access_list_default
  policy_create_default      = var.policy_create_default
  policy_name_append_default = var.policy_name_append_default
  policy_name_prefix_default = var.policy_name_prefix_default
  queue_map                  = local.lx_map
  std_map                    = var.std_map
}
