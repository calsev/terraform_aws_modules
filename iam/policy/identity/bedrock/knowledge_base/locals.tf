locals {
  l0_map = {
    for k, v in var.policy_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, {
      name_list_knowledge_base = v.name_list_knowledge_base == null ? var.policy_name_list_knowledge_base_default : v.name_list_knowledge_base
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      arn_list_knowledge_base = [
        for name in sort(distinct(local.l1_map[k].name_list_knowledge_base)) : startswith(name, "arn:") ? name : "arn:${var.std_map.iam_partition}:bedrock:${var.std_map.aws_region_name}:${var.std_map.aws_account_id}:knowledge-base/${name}"
      ]
    }
  }
  l3_map = {
    for k, v in local.l0_map : k => {
      resource_map = {
        knowledge-base = local.l2_map[k].arn_list_knowledge_base
        star           = ["*"]
      }
    }
  }
  lx_map = {
    for k, _ in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k], local.l3_map[k])
  }
  output_data = {
    for k, v in local.lx_map : k => merge(
      {
        for k_attr, v_attr in v : k_attr => v_attr if !contains([], k_attr)
      },
      module.this_policy.data[k],
      {
      }
    )
  }
}
