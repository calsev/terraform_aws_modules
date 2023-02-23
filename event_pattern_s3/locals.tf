locals {
  object_key = var.object_key_suffix == null ? [local.object_key_prefix] : [local.object_key_prefix, local.object_key_suffix]
  object_key_prefix = {
    prefix = var.object_key_prefix
  }
  object_key_suffix = {
    # https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-event-patterns-content-based-filtering.html
    suffix = var.object_key_suffix
  }
  pattern = {
    account = [
      var.aws_account_id == null ? var.std_map.aws_account_id : var.aws_account_id
    ]
    detail = {
      bucket = {
        name = [
          var.bucket_name,
        ]
      }
      object = {
        key = local.object_key
      }
      reason = var.action_list
    }
    source = [
      "aws.s3",
    ]
  }
}
