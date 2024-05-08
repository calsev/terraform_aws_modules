locals {
  arn_list_job_evaluation = [
    for name in sort(distinct(var.name_list_job_evaluation)) : startswith(name, "arn:") ? name : "arn:${var.std_map.iam_partition}:bedrock:${var.std_map.aws_region_name}:${var.std_map.aws_account_id}:evaluation-job/${name}"
  ]
  arn_list_job_model_customization = [
    for name in sort(distinct(var.name_list_job_model_customization)) : startswith(name, "arn:") ? name : "arn:${var.std_map.iam_partition}:bedrock:${var.std_map.aws_region_name}:${var.std_map.aws_account_id}:model-customization-job/${name}"
  ]
  arn_list_job_model_evaluation = [
    for name in sort(distinct(var.name_list_job_model_evaluation)) : startswith(name, "arn:") ? name : "arn:${var.std_map.iam_partition}:bedrock:${var.std_map.aws_region_name}:${var.std_map.aws_account_id}:model-evaluation-job/${name}"
  ]
  arn_list_job_model_invocation = [
    for name in sort(distinct(var.name_list_job_model_invocation)) : startswith(name, "arn:") ? name : "arn:${var.std_map.iam_partition}:bedrock:${var.std_map.aws_region_name}:${var.std_map.aws_account_id}:model-invocation-job/${name}"
  ]
  arn_list_model_custom = [
    for name in sort(distinct(var.name_list_model_custom)) : startswith(name, "arn:") ? name : "arn:${var.std_map.iam_partition}:bedrock:${var.std_map.aws_region_name}:${var.std_map.aws_account_id}:custom-model/${name}"
  ]
  arn_list_model_foundation = [
    for name in sort(distinct(var.name_list_model_foundation)) : startswith(name, "arn:") ? name : "arn:${var.std_map.iam_partition}:bedrock:${var.std_map.aws_region_name}::foundation-model/${name}"
  ]
  arn_list_model_provisioned = [
    for name in sort(distinct(var.name_list_model_provisioned)) : startswith(name, "arn:") ? name : "arn:${var.std_map.iam_partition}:bedrock:${var.std_map.aws_region_name}:${var.std_map.aws_account_id}:provisioned-model/${name}"
  ]
}
