locals {
  create_permission_x_map = {
    for v in flatten([
      for k, v in local.lx_map : [
        for aws_account_id in v.aws_account_id_list : merge(v, {
          aws_account_id = aws_account_id
          k_all          = "${k}_${aws_account_id}"
          k_layer        = k
        })
      ]
    ]) : v.k_all => v
  }
  l0_map = {
    for k, v in var.permission_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, {
      aws_account_id_list = v.aws_account_id_list == null ? var.permission_aws_account_id_list_default == null ? [var.std_map.aws_account_id] : var.permission_aws_account_id_list_default : v.aws_account_id_list
      # arn:aws:lambda:region:account:layer:name:version
      layer_arn      = join(":", slice(split(":", v.layer_version_arn), 0, 7))
      skip_destroy   = v.skip_destroy == null ? var.permission_skip_destroy_default : v.skip_destroy
      version_number = tonumber(split(":", v.layer_version_arn)[7])
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
    }
  }
  lx_map = {
    for k, _ in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k])
  }
  output_data = {
    for k, v in local.lx_map : k => merge(
      {
        for k_attr, v_attr in v : k_attr => v_attr if !contains([], k_attr)
      },
      {
        permission_map = {
          for aws_account_id in v.aws_account_id_list : aws_account_id => {
            revision_id  = aws_lambda_layer_version_permission.this_permission["${k}_${aws_account_id}"].revision_id
            statement_id = aws_lambda_layer_version_permission.this_permission["${k}_${aws_account_id}"].statement_id
          }
        }
      }
    )
  }
}
