locals {
  assume_role_doc_map = {
    for k, _ in local.assume_role_policy_map : k => jsondecode(data.aws_iam_policy_document.assume_role_policy[k].json)
  }
  assume_role_policy_map = {
    batch = ["batch"]
    #code_build    = ["codebuild"] # Use iam_role_code_build instead
    code_pipeline = ["codepipeline"]
    code_star     = ["codestar"]
    ec2           = ["ec2"]
    ecs           = ["ecs"]
    ecs_task      = ["ecs-tasks"]
    events        = ["events"]
    lambda        = ["lambda"]
    sagemaker     = ["sagemaker"]
    spot_fleet    = ["spotfleet"]
    states        = ["states"]
  }
}