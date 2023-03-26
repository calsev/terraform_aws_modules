module "vpc_map" {
  source                              = "../vpc_id_map"
  vpc_map                             = var.fs_map
  vpc_az_key_list_default             = var.vpc_az_key_list_default
  vpc_key_default                     = var.vpc_key_default
  vpc_security_group_key_list_default = var.vpc_security_group_key_list_default
  vpc_segment_key_default             = var.vpc_segment_key_default
  vpc_data_map                        = var.vpc_data_map
}

resource "aws_efs_file_system" "this_fs" {
  for_each       = local.fs_map
  creation_token = each.value.resource_name
  encrypted      = each.value.encrypt_file_system
  tags           = each.value.tags
}

resource "aws_efs_mount_target" "this_mount_target" {
  for_each        = local.subnet_flattened_map
  file_system_id  = aws_efs_file_system.this_fs[each.value.k_fs].id
  subnet_id       = each.value.subnet_id
  security_groups = each.value.vpc_security_group_id_list
}

data "aws_iam_policy_document" "this_policy_doc" {
  for_each = local.fs_map
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
  for_each                           = local.fs_map
  bypass_policy_lockout_safety_check = false
  file_system_id                     = aws_efs_file_system.this_fs[each.key].id
  policy                             = data.aws_iam_policy_document.this_policy_doc[each.key].json
}
