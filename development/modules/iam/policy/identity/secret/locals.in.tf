locals {
  l0_map = {
    for k, v in var.policy_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, {
      # tflint-ignore: terraform_unused_declarations
      mutual_exclusion_secret = v.ssm_param_name == null && v.sm_secret_name != null || v.ssm_param_name != null && v.sm_secret_name == null ? null : file("ERROR: Exactly one secret is required")
      service_name            = v.ssm_param_name == null ? "secretsmanager" : "ssm"
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      resource_map = v.ssm_param_name == null ? {
        secret = ["arn:${var.std_map.iam_partition}:${local.l1_map[k].service_name}:${var.std_map.aws_region_name}:${var.std_map.aws_account_id}:secret:${v.sm_secret_name == null ? "" : v.sm_secret_name}*"]
        star   = ["*"]
        } : {
        parameter = ["arn:${var.std_map.iam_partition}:${local.l1_map[k].service_name}:${var.std_map.aws_region_name}:${var.std_map.aws_account_id}:parameter/${v.ssm_param_name}"]
        star      = ["*"]
      }
    }
  }
  lx_map = {
    for k, _ in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k])
  }
  output_data = {
    for k, v in local.lx_map : k => merge(
      {
        for k_attr, v_attr in v : k_attr => v_attr if !contains(["mutual_exclusion_secret"], k_attr)
      },
      module.this_policy.data[k],
      {
      }
    )
  }
}
