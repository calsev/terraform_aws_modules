module "assume_role_policy" {
  source = "../../../iam/policy/assume_role"
  account_map = {
    SupportAccount = {
      aws_account_id_list = local.support_account_id_list
    }
  }
  std_map = var.std_map
}

module "support_access_role" {
  source           = "../../../iam/role/base"
  assume_role_json = jsonencode(module.assume_role_policy.iam_policy_doc_assume_role)
  name             = "support_access"
  role_policy_managed_name_map_default = {
    support_access = "AWSSupportAccess"
  }
  std_map = var.std_map
}
