locals {
  image_tag_list_map = {
    for k, v in var.repo_map : k => v.image_tag_list == null ? var.repo_image_tag_list_default : v.image_tag_list
  }
  lifecycle_rule_tag_list_map = {
    for k, v in local.repo_map : k => [
      for i_tag, tag in v.image_tag_list :
      {
        rulePriority = i_tag + 1 + length(v.lifecycle_rule_list)
        selection = {
          countNumber   = v.image_tag_max_count
          countType     = "imageCountMoreThan"
          tagPrefixList = [tag]
          tagStatus     = "tagged"
        }
        action = {
          type = "expire"
        }
      }
    ]
  }
  lifecycle_rule_list_map = {
    for k, v in local.repo_map : k => concat(v.lifecycle_rule_list, local.lifecycle_rule_tag_list_map[k])
  }
  name_infix_map = {
    for k, v in var.repo_map : k => v.name_infix == null ? var.repo_name_infix_default : v.name_infix
  }
  output_data = {
    for k_repo, v_repo in local.repo_map : k_repo => merge(
      {
        for k, v in v_repo : k => v if !contains(["iam_policy_json"], k)
      },
      module.repo_policy[k_repo].data,
      {
        lifecycle_rule_tag_list = local.lifecycle_rule_list_map[k_repo]
        repo_arn                = aws_ecr_repository.this_repo[k_repo].arn
      },
    )
  }
  repo_map = {
    for k, v in var.repo_map : k => merge(v, {
      base_image          = v.base_image
      create_policy       = v.create_policy == null ? var.repo_create_policy_default : v.create_policy
      iam_policy_json     = v.iam_policy_json == null ? var.repo_iam_policy_json_default : v.iam_policy_json
      image_tag_list      = local.image_tag_list_map[k]
      image_tag_max_count = v.image_tag_max_count == null ? var.repo_image_tag_max_count_default : v.image_tag_max_count
      lifecycle_rule_list = v.lifecycle_rule_list == null ? var.repo_lifecycle_rule_list_default : v.lifecycle_rule_list
      name_infix          = local.name_infix_map[k]
      repo_name           = local.name_infix_map[k] ? local.resource_name_map[k] : k
      name_context        = local.resource_name_map[k]
      tags = v.base_image == null ? local.tag_map[k] : merge(
        local.tag_map[k],
        {
          # Below is the interface for ecr-mirror
          upstream-image = v.base_image
          upstream-tags  = join("/", local.image_tag_list_map[k])
        }
      )
    })
  }
  resource_name_map = {
    for k, v in var.repo_map : k => "${var.std_map.resource_name_prefix}${replace(k, "/[_.]/", "-")}${var.std_map.resource_name_suffix}"
  }
  tag_map = {
    for k, v in var.repo_map : k => merge(
      var.std_map.tags,
      {
        Name = local.resource_name_map[k]
      }
    )
  }
}
