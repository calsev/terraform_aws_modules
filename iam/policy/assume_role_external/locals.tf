locals {
  sid_map = {
    for k, v in var.account_map : title(k) => merge(
      {
        identifier_list = [
          for aws_account_id in v.aws_account_id_list : "arn:aws:iam::${aws_account_id}:root"
        ]
      },
      length(v.external_id_list) != 0 ? {
        condition_map = {
          external_id = {
            test       = "StringEquals"
            value_list = v.external_id_list
            variable   = "sts:ExternalId"
          }
        }
      } : {}
    )
  }
}
