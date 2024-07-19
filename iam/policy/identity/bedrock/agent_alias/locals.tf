locals {
  arn_list_agent = [
    for name in sort(distinct(var.name_list_agent)) : startswith(name, "arn:") ? name : "arn:${var.std_map.iam_partition}:bedrock:${var.std_map.aws_region_name}:${var.std_map.aws_account_id}:agent/${name}"
  ]
  arn_list_agent_alias = flatten([
    for agent, alias_list in var.name_map_agent_alias : startswith(agent, "arn:") ? [agent] : [
      for alias in sort(distinct(alias_list)) : "arn:${var.std_map.iam_partition}:bedrock:${var.std_map.aws_region_name}:${var.std_map.aws_account_id}:agent-alias/${agent}/${alias}"
    ]
  ])
}
