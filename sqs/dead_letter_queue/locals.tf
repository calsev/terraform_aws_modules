module "name_map" {
  source                          = "../../name_map"
  name_append_default             = var.name_append_default
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_map                        = local.l0_map
  name_prefix_default             = var.name_prefix_default
  name_prepend_default            = var.name_prepend_default
  name_regex_allow_list           = var.name_regex_allow_list
  name_suffix_default             = var.name_suffix_default
  std_map                         = var.std_map
}

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
