locals {
  pattern = merge(
    {
      account = [
        var.aws_account_id == null ? var.std_map.aws_account_id : var.aws_account_id
      ]
      detail = merge(
        {
          bucket = {
            name = [
              var.bucket_name,
            ]
          }
          object = length(var.object_key_list) == 0 ? {} : {
            key = [
              for val in var.object_key_list : {
                # https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-event-patterns-content-based-filtering.html
                (var.object_key_is_prefix ? "prefix" : "suffix") = val
              }
            ]
          }
        },
        var.action_list == null ? null : length(var.action_list) == 0 ? null : {
          reason = var.action_list
        },
      )
      source = [
        "aws.s3",
      ]
    },
    var.detail_type_list == null ? {} : length(var.detail_type_list) == 0 ? {} : {
      detail-type = var.detail_type_list
    },
  )
}
