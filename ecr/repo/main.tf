resource "aws_ecr_repository" "this_repo" {
  for_each = local.repo_map
  image_scanning_configuration {
    scan_on_push = true
  }
  image_tag_mutability = "MUTABLE"
  name                 = each.value.name_effective
  tags                 = each.value.tags
}

resource "aws_ecr_lifecycle_policy" "this_lifecycle" {
  for_each = local.repo_map
  policy = jsonencode(
    {
      rules = each.value.lifecycle_rule_list
    }
  )
  repository = aws_ecr_repository.this_repo[each.key].id
}

data "aws_iam_policy_document" "base_policy" {
  for_each                  = local.repo_map
  override_policy_documents = each.value.iam_policy_json == null ? [] : [each.value.iam_policy_json]
  statement {
    actions = [
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer",
    ]
    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }
    sid = "LambdaGetImage"
  }
}

resource "aws_ecr_repository_policy" "repo_policy" {
  for_each   = local.repo_map
  policy     = each.value.iam_policy_json == null ? data.aws_iam_policy_document.base_policy[each.key].json : each.value.iam_policy_json
  repository = aws_ecr_repository.this_repo[each.key].id
}
