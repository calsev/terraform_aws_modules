locals {
  support_account_id_list = sort(distinct(concat(var.support_account_id_list, [var.std_map.aws_account_id])))
  output_data = {
    iam_role_arn_support_access  = module.support_access_role.data.iam_role_arn
    iam_role_data_support_access = module.support_access_role.data
  }
}
