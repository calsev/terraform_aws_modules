data "aws_iam_policy_document" "efs_read" {
  statement {
    actions = local.efs_read_actions
    resources = [
      aws_efs_file_system.this_fs.arn,
    ]
  }
  statement {
    actions = [
      "ec2:DescribeAvailabilityZones",
    ]
    resources = [
      "*",
    ]
  }
}

data "aws_iam_policy_document" "efs_write" {
  statement {
    actions = local.efs_write_actions
    resources = [
      aws_efs_file_system.this_fs.arn,
    ]
  }
}

resource "aws_iam_policy" "iam_policy_efs_read" {
  for_each = var.create_policies ? { this = {} } : {}
  name     = local.efs_read_policy_name
  policy   = data.aws_iam_policy_document.efs_read.json
  tags = merge(
    var.std_map.tags,
    {
      Name = local.efs_read_policy_name
    }
  )
}

resource "aws_iam_policy" "iam_policy_efs_write" {
  for_each = var.create_policies ? { this = {} } : {}
  name     = local.efs_write_policy_name
  policy   = data.aws_iam_policy_document.efs_write.json
  tags = merge(
    var.std_map.tags,
    {
      Name = local.efs_write_policy_name
    }
  )
}

resource "aws_iam_role_policy" "efs_read" {
  for_each = local.iam_role_id_efs_read_map
  name     = "efs_read"
  policy   = data.aws_iam_policy_document.efs_read.json
  role     = each.key
}

resource "aws_iam_role_policy" "efs_write_read" {
  for_each = local.iam_role_id_efs_write_map
  name     = "efs_read"
  policy   = data.aws_iam_policy_document.efs_read.json
  role     = each.key
}

resource "aws_iam_role_policy" "efs_write" {
  for_each = local.iam_role_id_efs_write_map
  name     = "efs_write"
  policy   = data.aws_iam_policy_document.efs_write.json
  role     = each.key
}
