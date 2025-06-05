resource "aws_efs_file_system" "this_fs" {
  for_each       = local.lx_map
  creation_token = each.value.name_context
  encrypted      = each.value.encrypt_file_system
  tags           = each.value.tags
}

resource "aws_efs_mount_target" "this_mount_target" {
  for_each        = local.create_subnet_x_map
  file_system_id  = aws_efs_file_system.this_fs[each.value.k_fs].id
  subnet_id       = each.value.subnet_id
  security_groups = each.value.vpc_security_group_id_list
}

data "aws_iam_policy_document" "this_policy_doc" {
  for_each = local.lx_map
  statement {
    actions = [
      "elasticfilesystem:ClientMount",
      "elasticfilesystem:ClientRootAccess",
      "elasticfilesystem:ClientWrite",
    ]
    condition {
      test     = "Bool"
      variable = "elasticfilesystem:AccessedViaMountTarget"
      values   = ["true"]
    }
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    resources = [aws_efs_file_system.this_fs[each.key].arn]
    sid       = "FileSystemAccess"
  }
  statement {
    actions = [
      "*",
    ]
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
    effect = "Deny"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    resources = [aws_efs_file_system.this_fs[each.key].arn]
    sid       = "EnforceSecureTransport"
  }
}

resource "aws_efs_file_system_policy" "policy" {
  for_each                           = local.lx_map
  bypass_policy_lockout_safety_check = false
  file_system_id                     = aws_efs_file_system.this_fs[each.key].id
  policy                             = data.aws_iam_policy_document.this_policy_doc[each.key].json
}

resource "aws_efs_access_point" "this_access_point" {
  for_each       = local.create_access_point_x_map
  file_system_id = aws_efs_file_system.this_fs[each.value.k_fs].id
  posix_user {
    gid            = each.value.user_gid
    secondary_gids = each.value.user_gid_secondary_list
    uid            = each.value.user_uid
  }
  root_directory {
    creation_info {
      owner_gid   = each.value.owner_gid
      owner_uid   = each.value.owner_uid
      permissions = each.value.permission_mode
    }
    path = each.value.path
  }
  tags = each.value.tags
}
