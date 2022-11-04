resource "aws_ecr_repository" "this_repo" {
  for_each = local.repo_map
  image_scanning_configuration {
    scan_on_push = true
  }
  image_tag_mutability = "MUTABLE"
  name                 = each.value.repo_name
  tags                 = each.value.tags
}

resource "aws_ecr_lifecycle_policy" "this_lifecycle" {
  for_each = local.lifecycle_rule_list_map
  policy = jsonencode(
    {
      rules = each.value
    }
  )
  repository = aws_ecr_repository.this_repo[each.key].id
}

data "aws_iam_policy_document" "empty_policy" {
  statement {
    actions = ["*"]
    condition {
      test     = "IpAddress"
      values   = ["0.0.0.0"]
      variable = "aws:SourceIp"
    }
    effect = "Deny"
    principals {
      identifiers = ["*"]
      type        = "*"
    }
    sid = "EmptyPolicy"
  }
}

resource "aws_ecr_repository_policy" "repo_policy" {
  for_each   = local.repo_map
  policy     = each.value.iam_policy_json == null ? data.aws_iam_policy_document.empty_policy.json : each.value.iam_policy_json
  repository = aws_ecr_repository.this_repo[each.key].id
}
