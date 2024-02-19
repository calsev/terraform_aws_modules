module "create_name_map" {
  source              = "../../../name_map"
  name_infix_default  = var.policy_name_infix_default
  name_map            = local.policy_create_flattened_map
  name_prefix_default = var.policy_name_prefix_default
  std_map             = var.std_map
}

locals {
  l1_map = {
    for k, v in var.policy_map : k => {
      policy_create_map = {
        for k_create, v_create in v.policy_create_json_map : k_create => merge(local.policy_create_flattened_map["${k}-${k_create}"], module.create_name_map.data["${k}-${k_create}"])
      }
      policy_attach_arn_map = {
        for name, arn in v.policy_attach_arn_map : "2-attached-${name}" => arn
      }
      policy_inline_doc_map = {
        for name, doc in v.policy_inline_json_map : name => jsondecode(doc)
      }
      policy_managed_arn_map = {
        for name, policy in v.policy_managed_name_map : "1-managed-${name}" => "arn:${var.std_map.iam_partition}:iam::aws:policy/${policy}"
      }
    }
  }
  l2_map = {
    for k, v in var.policy_map : k => {
      policy_create_arn_map = {
        for k_create, v_create in local.l1_map[k].policy_create_map : "3-created-${k_create}" => aws_iam_policy.this_created_policy[v_create.k_create].arn
      }
    }
  }
  l3_map = {
    for k, v in var.policy_map : k => {
      policy_all_attached_arn_map = merge(local.l1_map[k].policy_managed_arn_map, local.l1_map[k].policy_attach_arn_map, local.l2_map[k].policy_create_arn_map)
    }
  }
  policy_map = {
    for k, v in var.policy_map : k => merge(local.l1_map[k], local.l2_map[k], local.l3_map[k])
  }
  policy_attach_list_flattened = flatten([
    for k, v in local.policy_map : [
      for k_attach, v_attach in v.policy_all_attached_arn_map : merge(v, {
        iam_policy_arn = v_attach
        k              = k
        k_full         = "${k}-${k_attach}"
      })
    ]
  ])
  policy_attach_map_flattened = {
    for v in local.policy_attach_list_flattened : v.k_full => v
  }
  policy_create_flattened_list = flatten([
    for k, v in var.policy_map : [
      for k_create, v_create in v.policy_create_json_map : {
        k_create       = "${k}-${k_create}"
        iam_policy_doc = jsondecode(v_create)
      }
    ]
  ])
  policy_create_flattened_map = {
    for v in local.policy_create_flattened_list : v.k_create => v
  }
  policy_inline_list_flattened = flatten([
    for k, v in local.policy_map : [
      for k_inline, v_inline in v.policy_inline_doc_map : merge(v, {
        iam_policy_doc = v_inline
        k              = k
        k_inline       = k_inline
        k_full         = "${k}-${k_inline}"
      })
    ]
  ])
  policy_inline_map_flattened = {
    for v in local.policy_inline_list_flattened : v.k_full => v
  }
}
