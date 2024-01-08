locals {
  l1_map = {
    for k, v in var.role_map : k => merge(v, {
      embedded_role_policy_attach_arn_map   = v.embedded_role_policy_attach_arn_map == null ? var.embedded_role_policy_attach_arn_map_default : v.embedded_role_policy_attach_arn_map
      embedded_role_policy_create_json_map  = v.embedded_role_policy_create_json_map == null ? var.embedded_role_policy_create_json_map_default : v.embedded_role_policy_create_json_map
      embedded_role_policy_inline_json_map  = v.embedded_role_policy_inline_json_map == null ? var.embedded_role_policy_inline_json_map_default : v.embedded_role_policy_inline_json_map
      embedded_role_policy_managed_name_map = v.embedded_role_policy_managed_name_map == null ? var.embedded_role_policy_managed_name_map_default : v.embedded_role_policy_managed_name_map
      role_policy_attach_arn_map            = v.role_policy_attach_arn_map == null ? var.role_policy_attach_arn_map_default : v.role_policy_attach_arn_map
      role_policy_create_json_map           = v.role_policy_create_json_map == null ? var.role_policy_create_json_map_default : v.role_policy_create_json_map
      role_policy_inline_json_map           = v.role_policy_inline_json_map == null ? var.role_policy_inline_json_map_default : v.role_policy_inline_json_map
      role_policy_managed_name_map          = v.role_policy_managed_name_map == null ? var.role_policy_managed_name_map_default : v.role_policy_managed_name_map
    })
  }
  l2_map = {
    for k, _ in var.role_map : k => {
      embedded_role_policy_attach_arn_map = {
        for k_policy, v_policy in local.l1_map[k].embedded_role_policy_attach_arn_map : k_policy => v_policy.policy if v_policy.condition
      }
      embedded_role_policy_create_json_map = {
        for k_policy, v_policy in local.l1_map[k].embedded_role_policy_create_json_map : k_policy => v_policy.policy if v_policy.condition
      }
      embedded_role_policy_inline_json_map = {
        for k_policy, v_policy in local.l1_map[k].embedded_role_policy_inline_json_map : k_policy => v_policy.policy if v_policy.condition
      }
      embedded_role_policy_managed_name_map = {
        for k_policy, v_policy in local.l1_map[k].embedded_role_policy_managed_name_map : k_policy => v_policy.policy if v_policy.condition
      }
    }
  }
  l3_map = {
    for k, _ in var.role_map : k => {
      role_policy_attach_arn_map   = merge(local.l1_map[k].role_policy_attach_arn_map, local.l2_map[k].embedded_role_policy_attach_arn_map)
      role_policy_create_json_map  = merge(local.l1_map[k].role_policy_create_json_map, local.l2_map[k].embedded_role_policy_create_json_map)
      role_policy_inline_json_map  = merge(local.l1_map[k].role_policy_inline_json_map, local.l2_map[k].embedded_role_policy_inline_json_map)
      role_policy_managed_name_map = merge(local.l1_map[k].role_policy_managed_name_map, local.l2_map[k].embedded_role_policy_managed_name_map)
    }
  }
  output_data = {
    for k, v in var.role_map : k => {
      for k_attr, v_attr in merge(local.l1_map[k], local.l2_map[k], local.l3_map[k]) : k_attr => v_attr if !startswith(k_attr, "embedded_")
    }
  }
}
