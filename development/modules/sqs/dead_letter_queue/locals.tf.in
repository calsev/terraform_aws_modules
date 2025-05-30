{{ name.map() }}

locals {
  l0_map = {
    for k, v in var.queue_map : k => v
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
  lx_map = {
    for k, _ in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k])
  }
  output_data = {
    for k, v in local.lx_map : k => merge(
      {
        for k_attr, v_attr in v : k_attr => v_attr if !contains([], k_attr)
      },
      module.this_queue.data[k],
      {
      }
    )
  }
}
