{{ name.map() }}

locals {
  create_policy_map = {
    for k, v in local.lx_map : k => merge(v, {
      repo_name = v.name_effective
    })
  }
  l0_map = {
    for k, v in var.repo_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      iam_policy_json     = v.iam_policy_json == null ? var.repo_iam_policy_json_default : v.iam_policy_json
      image_tag_list      = v.image_tag_list == null ? var.repo_image_tag_list_default : v.image_tag_list
      image_tag_max_count = v.image_tag_max_count == null ? var.repo_image_tag_max_count_default : v.image_tag_max_count
      lifecycle_rule_list = v.lifecycle_rule_list == null ? var.repo_lifecycle_rule_list_default : v.lifecycle_rule_list
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      iam_policy_doc = local.l1_map[k].iam_policy_json == null ? null : jsondecode(local.l1_map[k].iam_policy_json)
      lifecycle_rule_list = concat(local.l1_map[k].lifecycle_rule_list, [
        for i_tag, tag in local.l1_map[k].image_tag_list : {
          rulePriority = i_tag + 1 + length(local.l1_map[k].lifecycle_rule_list)
          selection = {
            countNumber   = local.l1_map[k].image_tag_max_count
            countType     = "imageCountMoreThan"
            tagPrefixList = [tag]
            tagStatus     = "tagged"
          }
          action = {
            type = "expire"
          }
        }
      ])
      tags = merge(
        local.l1_map[k].tags,
        v.base_image == null ? {} : {
          # Below is the interface for ecr-mirror
          upstream-image = v.base_image
          upstream-tags  = join("/", local.l1_map[k].image_tag_list)
        },
      )
    }
  }
  lx_map = {
    for k, _ in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k])
  }
  output_data = {
    for k, v in local.lx_map : k => merge(
      {
        for k_attr, v_attr in v : k_attr => v_attr if !contains(["iam_policy_json"], k_attr)
      },
      module.repo_policy.data[k],
      {
        repo_arn = aws_ecr_repository.this_repo[k].arn
        repo_url = aws_ecr_repository.this_repo[k].repository_url
      }
    )
  }
}
