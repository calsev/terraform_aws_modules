locals {
  l0_map = {
    for k, v in var.policy_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, {
      name_list_agent      = v.name_list_agent == null ? var.policy_name_list_agent_default : v.name_list_agent
      name_map_agent_alias = v.name_map_agent_alias == null ? var.policy_name_map_agent_alias_default : v.name_map_agent_alias
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      arn_list_agent = [
        for name in sort(distinct(local.l1_map[k].name_list_agent)) : startswith(name, "arn:") ? name : "arn:${var.std_map.iam_partition}:bedrock:${var.std_map.aws_region_name}:${var.std_map.aws_account_id}:agent/${name}"
      ]
      arn_list_agent_alias = flatten([
        for agent, alias_list in local.l1_map[k].name_map_agent_alias : startswith(agent, "arn:") ? [agent] : [
          for alias in sort(distinct(alias_list)) : "arn:${var.std_map.iam_partition}:bedrock:${var.std_map.aws_region_name}:${var.std_map.aws_account_id}:agent-alias/${agent}/${alias}"
        ]
      ])
    }
  }
  l3_map = {
    for k, v in local.l0_map : k => {
      resource_map = {
        agent       = local.l2_map[k].arn_list_agent
        agent-alias = local.l2_map[k].arn_list_agent_alias
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
