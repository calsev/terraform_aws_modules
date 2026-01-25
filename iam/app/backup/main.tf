module "managed_policies" {
  source = "../../../iam/policy/managed"
  policy_map = {
    backup_create     = "service-role/AWSBackupServiceRolePolicyForBackup"
    backup_restore    = "service-role/AWSBackupServiceRolePolicyForRestores"
    backup_s3_create  = "AWSBackupServiceRolePolicyForS3Backup"
    backup_s3_restore = "AWSBackupServiceRolePolicyForS3Restore"
  }
  std_map = var.std_map
}

module "backup_role" {
  source                   = "../../../iam/role/base"
  assume_role_service_list = ["backup"]
  role_policy_attach_arn_map_default = {
    backup_create    = module.managed_policies.data.iam_policy_arn_backup_create
    backup_s3_create = module.managed_policies.data.iam_policy_arn_backup_s3_create
  }
  name    = "backup_create"
  std_map = var.std_map
}

module "restore_role" {
  source                   = "../../../iam/role/base"
  assume_role_service_list = ["backup"]
  name                     = "backup_restore"
  role_policy_attach_arn_map_default = {
    backup_restore    = module.managed_policies.data.iam_policy_arn_backup_restore
    backup_s3_restore = module.managed_policies.data.iam_policy_arn_backup_s3_restore
  }
  std_map = var.std_map
}
