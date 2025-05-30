module "create_name_map" {
  source              = "../../../name_map"
  name_infix_default  = var.policy_name_infix_default
  name_map            = local.create_policy_x_map
  name_prefix_default = var.policy_name_prefix_default
  std_map             = var.std_map
}

locals {
  create_policy_1_list = flatten([
    for k, v in local.l1_map : [ # Non-stanadard
      for k_create, v_create in v.policy_create_json_map : {
        k_create       = "${k}-${k_create}"
        iam_policy_doc = jsondecode(v_create)
      }
    ]
  ])
  create_policy_x_map = {
    for v in local.create_policy_1_list : v.k_create => v
  }
  l0_map = {
    for k, v in var.policy_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => {
      policy_attach_arn_map   = v.policy_attach_arn_map == null ? var.policy_attach_arn_map_default : v.policy_attach_arn_map
      policy_create_json_map  = v.policy_create_json_map == null ? var.policy_create_json_map_default : v.policy_create_json_map
      policy_inline_json_map  = v.policy_inline_json_map == null ? var.policy_inline_json_map_default : v.policy_inline_json_map
      policy_managed_name_map = v.policy_managed_name_map == null ? var.policy_managed_name_map_default : v.policy_managed_name_map
    }
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      policy_create_map = {
        for k_create, v_create in local.l1_map[k].policy_create_json_map : k_create => merge(local.create_policy_x_map["${k}-${k_create}"], module.create_name_map.data["${k}-${k_create}"])
      }
      policy_attach_arn_map = {
        for name, arn in local.l1_map[k].policy_attach_arn_map : "2-attached-${name}" => arn
      }
      policy_inline_doc_map = {
        for name, doc in local.l1_map[k].policy_inline_json_map : name => jsondecode(doc)
      }
      policy_managed_arn_map = {
        for name, policy in local.l1_map[k].policy_managed_name_map : "1-managed-${name}" => "arn:${var.std_map.iam_partition}:iam::aws:policy/${policy}"
      }
    }
  }
  lx_map = {
    for k, v in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k])
  }
  o1_map = {
    for k, v in local.lx_map : k => {
      policy_create_arn_map = {
        for k_create, v_create in local.l2_map[k].policy_create_map : "3-created-${k_create}" => aws_iam_policy.this_created_policy[v_create.k_create].arn
      }
    }
  }
  o2_map = {
    for k, v in local.lx_map : k => {
      policy_all_attached_arn_map = merge(local.l2_map[k].policy_managed_arn_map, local.l2_map[k].policy_attach_arn_map, local.o1_map[k].policy_create_arn_map)
    }
  }
  ox_map = {
    for k, v in local.lx_map : k => merge(v, local.o1_map[k], local.o2_map[k])
  }
  policy_attach_1_list = flatten([
    for k, v in local.ox_map : [
      for k_attach, v_attach in v.policy_all_attached_arn_map : merge(v, {
        iam_policy_arn = v_attach
        k              = k
        k_full         = "${k}-${k_attach}"
      })
    ]
  ])
  policy_attach_x_map = {
    for v in local.policy_attach_1_list : v.k_full => v
  }
  policy_inline_1_list = flatten([
    for k, v in local.lx_map : [
      for k_inline, v_inline in v.policy_inline_doc_map : merge(v, {
        iam_policy_doc = v_inline
        k              = k
        k_inline       = k_inline
        k_full         = "${k}-${k_inline}"
      })
    ]
  ])
  policy_inline_x_map = {
    for v in local.policy_inline_1_list : v.k_full => v
  }
}
