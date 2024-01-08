module "this_policy" {
  source   = "../iam/policy/identity/efs"
  for_each = local.fs_map
  efs_arn  = aws_efs_file_system.this_fs[each.key].arn
  name     = each.value.policy_name
  std_map  = var.std_map
}
