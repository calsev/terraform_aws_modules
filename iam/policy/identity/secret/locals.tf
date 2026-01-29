locals {
  l0_map = {
    for k, v in var.policy_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, {
      sm_secret_name_list = v.sm_secret_name == null ? v.sm_secret_name_list : concat(v.sm_secret_name_list, [v.sm_secret_name])
      ssm_param_name_list = v.ssm_param_name == null ? v.ssm_param_name_list : concat(v.ssm_param_name_list, [v.ssm_param_name])
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      # tflint-ignore: terraform_unused_declarations
      mutual_exclusion_secret = length(local.l1_map[k].sm_secret_name_list) == 0 && length(local.l1_map[k].ssm_param_name_list) != 0 || length(local.l1_map[k].sm_secret_name_list) != 0 && length(local.l1_map[k].ssm_param_name_list) == 0 ? null : file("ERROR: Exactly one secret is required")
      service_name            = length(local.l1_map[k].ssm_param_name_list) == 0 ? "secretsmanager" : "ssm"
    }
  }
  l3_map = {
    for k, v in local.l0_map : k => {
      resource_map = length(local.l1_map[k].ssm_param_name_list) == 0 ? {
        secret = [
          for secret_name in local.l1_map[k].sm_secret_name_list :
          "arn:${var.std_map.iam_partition}:${local.l2_map[k].service_name}:${var.std_map.aws_region_name}:${var.std_map.aws_account_id}:secret:${secret_name}*"
        ]
        star = ["*"]
        } : {
        parameter = [
          for param_name in local.l1_map[k].ssm_param_name_list :
          "arn:${var.std_map.iam_partition}:${local.l2_map[k].service_name}:${var.std_map.aws_region_name}:${var.std_map.aws_account_id}:parameter/${param_name}"
        ]
        star = ["*"]
      }
    }
  }
  lx_map = {
    for k, _ in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k], local.l3_map[k])
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
