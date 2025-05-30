locals {
  output_data = merge(module.managed_policies.data, {
    iam_role_arn_backup_create   = module.backup_role.data.iam_role_arn
    iam_role_arn_backup_restore  = module.restore_role.data.iam_role_arn
    iam_role_data_backup_create  = module.backup_role.data
    iam_role_data_backup_restore = module.restore_role.data
  })
}
