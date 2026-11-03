locals {
  l0_map = {
    for k, v in var.policy_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, {
      repo_name_list = v.repo_name == null ? v.repo_name_list : concat(v.repo_name_list, [v.repo_name])
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      # tflint-ignore: terraform_unused_declarations
      validate_repo = length(local.l1_map[k].repo_name_list) != 0 ? null : file("ERROR: At least one repo is required")
      repo_arn_list = [
        for repo_name in local.l1_map[k].repo_name_list :
        "arn:${var.std_map.iam_partition}:ecr:${var.std_map.aws_region_name}:${var.std_map.aws_account_id}:repository/${repo_name}"
      ]
    }
  }
  l3_map = {
    for k, v in local.l0_map : k => {
      # Kept for single-repo callers
      repo_arn = local.l2_map[k].repo_arn_list[0]
      resource_map = {
        repo = local.l2_map[k].repo_arn_list
        star = ["*"]
      }
    }
  }
  lx_map = {
    for k, _ in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k], local.l3_map[k])
  }
  output_data = {
    for k, v in local.lx_map : k => merge(
      {
        for k_attr, v_attr in v : k_attr => v_attr if !contains(["validate_repo"], k_attr)
      },
      module.this_policy.data[k],
      {
      }
    )
  }
}
