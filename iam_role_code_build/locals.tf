locals {
  attach_policy_arn_map_1 = merge(
    var.policy_attach_arn_map,
    {
      artifact_read_write = var.ci_cd_account_data.bucket.iam_policy_arn_map.read_write
      log_write           = var.log_public_access ? var.ci_cd_account_data.log_public.iam_policy_arn_map.write : var.ci_cd_account_data.log.iam_policy_arn_map.write
    },
  )
  attach_policy_arn_map_2 = !var.vpc_access ? local.attach_policy_arn_map_1 : merge(
    local.attach_policy_arn_map_1,
    {
      vpc_net = var.ci_cd_account_data.policy.vpc_net.iam_policy_arn
    },
  )
  policy_inline_json_map = var.log_bucket_name == null ? var.policy_inline_json_map : merge(var.policy_inline_json_map, {
    log_s3_write = jsonencode(module.s3_log_policy["this"].data.iam_policy_doc)
  })
}
