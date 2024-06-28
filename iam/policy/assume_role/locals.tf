locals {
  action_list = [
    "sts:AssumeRole",
  ]
  sid_map = merge(
    {
      for k, v in var.account_map : title(k) => merge(
        {
          condition_map = length(v.external_id_list) == 0 ? {} : {
            external_id = {
              test       = "StringEquals"
              value_list = v.external_id_list
              variable   = "sts:ExternalId"
            }
          }
        },
        {
          identifier_list = [
            for aws_account_id in v.aws_account_id_list : "arn:${var.std_map.iam_partition}:iam::${aws_account_id}:root"
          ]
          identifier_type = "AWS"
        },
      )
    },
    length(var.service_list) > 0 ? {
      Service = {
        condition_map   = {}
        identifier_list = [for service in sort(var.service_list) : "${service}.amazonaws.com"]
        identifier_type = "Service"
      }
    } : {},
    {
      for k_sid, v_sid in var.sid_map : k_sid => {
        condition_map   = v_sid.condition_map == null ? {} : v_sid.condition_map
        identifier_list = v_sid.identifier_list == null ? var.sid_identifier_list_default : v_sid.identifier_list
        identifier_type = v_sid.identifier_type == null ? var.sid_identifier_type_default : v_sid.identifier_type
      }
    },
  )
}
