locals {
  l0_map = {
    for k, v in var.policy_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, {
      name_list_application_inference_profile = v.name_list_application_inference_profile == null ? var.policy_name_list_application_inference_profile_default : v.name_list_application_inference_profile
      name_list_job_evaluation                = v.name_list_job_evaluation == null ? var.policy_name_list_job_evaluation_default : v.name_list_job_evaluation
      name_list_job_model_customization       = v.name_list_job_model_customization == null ? var.policy_name_list_job_model_customization_default : v.name_list_job_model_customization
      name_list_job_model_evaluation          = v.name_list_job_model_evaluation == null ? var.policy_name_list_job_model_evaluation_default : v.name_list_job_model_evaluation
      name_list_job_model_invocation          = v.name_list_job_model_invocation == null ? var.policy_name_list_job_model_invocation_default : v.name_list_job_model_invocation
      name_list_inference_profile             = v.name_list_inference_profile == null ? var.policy_name_list_inference_profile_default : v.name_list_inference_profile
      name_list_model_custom                  = v.name_list_model_custom == null ? var.policy_name_list_model_custom_default : v.name_list_model_custom
      name_list_model_foundation              = v.name_list_model_foundation == null ? var.policy_name_list_model_foundation_default : v.name_list_model_foundation
      name_list_model_provisioned             = v.name_list_model_provisioned == null ? var.policy_name_list_model_provisioned_default : v.name_list_model_provisioned
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      arn_list_application_inference_profile = [
        for name in sort(distinct(local.l1_map[k].name_list_application_inference_profile)) : startswith(name, "arn:") ? name : "arn:${var.std_map.iam_partition}:bedrock:*:${var.std_map.aws_account_id}:application-inference-profile/${name}"
      ]
      arn_list_job_evaluation = [
        for name in sort(distinct(local.l1_map[k].name_list_job_evaluation)) : startswith(name, "arn:") ? name : "arn:${var.std_map.iam_partition}:bedrock:${var.std_map.aws_region_name}:${var.std_map.aws_account_id}:evaluation-job/${name}"
      ]
      arn_list_job_model_customization = [
        for name in sort(distinct(local.l1_map[k].name_list_job_model_customization)) : startswith(name, "arn:") ? name : "arn:${var.std_map.iam_partition}:bedrock:${var.std_map.aws_region_name}:${var.std_map.aws_account_id}:model-customization-job/${name}"
      ]
      arn_list_job_model_evaluation = [
        for name in sort(distinct(local.l1_map[k].name_list_job_model_evaluation)) : startswith(name, "arn:") ? name : "arn:${var.std_map.iam_partition}:bedrock:${var.std_map.aws_region_name}:${var.std_map.aws_account_id}:model-evaluation-job/${name}"
      ]
      arn_list_job_model_invocation = [
        for name in sort(distinct(local.l1_map[k].name_list_job_model_invocation)) : startswith(name, "arn:") ? name : "arn:${var.std_map.iam_partition}:bedrock:${var.std_map.aws_region_name}:${var.std_map.aws_account_id}:model-invocation-job/${name}"
      ]
      arn_list_inference_profile = [
        for name in sort(distinct(local.l1_map[k].name_list_inference_profile)) : startswith(name, "arn:") ? name : "arn:${var.std_map.iam_partition}:bedrock:*:${var.std_map.aws_account_id}:inference-profile/${name}"
      ]
      arn_list_model_custom = [
        for name in sort(distinct(local.l1_map[k].name_list_model_custom)) : startswith(name, "arn:") ? name : "arn:${var.std_map.iam_partition}:bedrock:${var.std_map.aws_region_name}:${var.std_map.aws_account_id}:custom-model/${name}"
      ]
      arn_list_model_foundation = [
        for name in sort(distinct(local.l1_map[k].name_list_model_foundation)) : startswith(name, "arn:") ? name : "arn:${var.std_map.iam_partition}:bedrock:*::foundation-model/${name}"
      ]
      arn_list_model_provisioned = [
        for name in sort(distinct(local.l1_map[k].name_list_model_provisioned)) : startswith(name, "arn:") ? name : "arn:${var.std_map.iam_partition}:bedrock:${var.std_map.aws_region_name}:${var.std_map.aws_account_id}:provisioned-model/${name}"
      ]
    }
  }
  l3_map = {
    for k, v in local.l0_map : k => {
      resource_map = {
        application-inference-profile = local.l2_map[k].arn_list_application_inference_profile
        custom-model                  = local.l2_map[k].arn_list_model_custom
        evaluation-job                = local.l2_map[k].arn_list_job_evaluation
        foundation-model              = local.l2_map[k].arn_list_model_foundation
        inference-profile             = local.l2_map[k].arn_list_inference_profile
        model-customization-job       = local.l2_map[k].arn_list_job_model_customization
        model-evaluation-job          = local.l2_map[k].arn_list_job_model_evaluation
        model-invocation-job          = local.l2_map[k].arn_list_job_model_invocation
        provisioned-model             = local.l2_map[k].arn_list_model_provisioned
      }
    }
  }
  lx_map = {
    for k, _ in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k], local.l3_map[k])
  }
  output_data = {
    for k, v in local.lx_map : k => merge(
      {
        for k_attr, v_attr in v : k_attr => v_attr if !contains([], k_attr)
      },
      module.this_policy.data[k],
      {
      }
    )
  }
}
