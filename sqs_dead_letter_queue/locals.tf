module "name_map" {
  source   = "../name_map"
  name_map = local.l0_map
  std_map  = var.std_map
}

locals {
  l0_map = {
    for k, v in var.queue_map : "${k}${local.name_append}" => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      dead_letter_queue_enabled = v.dead_letter_queue_enabled == null ? var.queue_enabled_default : v.dead_letter_queue_enabled
      is_fifo                   = false
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      create_queue  = local.l1_map[k].dead_letter_queue_enabled
      policy_create = local.l1_map[k].dead_letter_queue_enabled ? v.dead_letter_policy_create == null ? var.policy_create_default : v.dead_letter_policy_create : false
    }
  }
  name_append = var.name_append == null ? "" : "-${var.name_append}"
  output_data = {
    for k, v in var.queue_map : k => merge(
      local.queue_map["${k}${local.name_append}"],
      module.this_queue.data["${k}${local.name_append}"],
    )
  }
  queue_map = {
    for k, v in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k])
  }
}
