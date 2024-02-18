locals {
  attach_policy_arn_map = merge(
    var.policy_attach_arn_map,
    {
      build_start     = module.start_build.data.iam_policy_arn_map.read_write
      code_connection = var.ci_cd_account_data.code_star.connection[var.code_star_connection_key].iam_policy_arn_map.read_write
      source_write    = var.ci_cd_account_data.bucket.iam_policy_arn_map.write
    },
  )
  output_data = merge(module.this_role.data, {
    start_build_policy = module.start_build.data
  })
}
