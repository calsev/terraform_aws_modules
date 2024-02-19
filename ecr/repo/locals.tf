module "name_map" {
  source                = "../../name_map"
  name_infix_default    = var.repo_name_infix_default
  name_map              = var.repo_map
  name_regex_allow_list = ["/"]
  std_map               = var.std_map
}

module "policy_map" {
  source                      = "../../iam/policy/name_map"
  name_map                    = var.repo_map
  policy_access_list_default  = var.policy_access_list_default
  policy_create_default       = var.policy_create_default
  policy_name_append_default  = var.policy_name_append_default
  policy_name_infix_default   = var.policy_name_infix_default
  policy_name_prefix_default  = var.policy_name_prefix_default
  policy_name_prepend_default = var.policy_name_prepend_default
  policy_name_suffix_default  = var.policy_name_suffix_default
  std_map                     = var.std_map
}

locals {
  l1_map = {
    for k, v in var.repo_map : k => merge(v, module.name_map.data[k], module.policy_map.data[k], {
      iam_policy_json     = v.iam_policy_json == null ? var.repo_iam_policy_json_default : v.iam_policy_json
      image_tag_list      = v.image_tag_list == null ? var.repo_image_tag_list_default : v.image_tag_list
      image_tag_max_count = v.image_tag_max_count == null ? var.repo_image_tag_max_count_default : v.image_tag_max_count
      lifecycle_rule_list = v.lifecycle_rule_list == null ? var.repo_lifecycle_rule_list_default : v.lifecycle_rule_list
    })
  }
  l2_map = {
    for k, v in var.repo_map : k => {
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
  output_data = {
    for k, v in local.repo_map : k => merge(
      {
        for k_repo, v_repo in v : k_repo => v_repo if !contains(["iam_policy_json"], k_repo)
      },
      module.repo_policy[k].data,
      {
        repo_arn = aws_ecr_repository.this_repo[k].arn
        repo_url = aws_ecr_repository.this_repo[k].repository_url
      },
    )
  }
  repo_map = {
    for k, v in var.repo_map : k => merge(local.l1_map[k], local.l2_map[k])
  }
}
