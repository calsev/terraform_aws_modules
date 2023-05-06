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
          object = {
            key = concat(
              var.object_key_prefix == null ? [] : [
                {
                  prefix = var.object_key_prefix
                },
              ],
              var.object_key_suffix == null ? [] : [
                {
                  # https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-event-patterns-content-based-filtering.html
                  suffix = var.object_key_suffix
                },
              ],
            )
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
    var.detail_type_list == null ? null : length(var.detail_type_list) == 0 ? null : {
      detail-type = var.detail_type_list
    },
  )
}
