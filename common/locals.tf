locals {
  access_title_map = {
    public_read       = "PublicRead"
    read              = "Read"
    public_read_write = "PublicReadWrite"
    read_write        = "ReadWrite"
    public_write      = "PublicWrite"
    write             = "Write"
  }
  assume_role_json = {
    for k, _ in local.assume_role_policy_map : k => data.aws_iam_policy_document.assume_role_policy[k].json
  }
  assume_role_policy_map = {
    batch = ["batch"]
    #code_build    = ["codebuild"] # Use iam_role_code_build instead
    code_pipeline = ["codepipeline"]
    code_star     = ["codestar"]
    ec2           = ["ec2"]
    ecs_task      = ["ecs-tasks"]
    events        = ["events"]
    lambda        = ["lambda"]
    sagemaker     = ["sagemaker"]
    spot_fleet    = ["spotfleet"]
    states        = ["states"]
    task_starter = [
      "batch",
      "ec2",
      "ecs",
      "ecs-tasks",
      "events",
      "lambda",
    ]
  }
  aws_region_abbreviation = local.aws_region_to_abbrev[var.std_var.aws_region_name]
  aws_region_to_abbrev = {
    us-east-1      = "usea1"
    us-east-2      = "usea2"
    us-west-1      = "uswe1"
    us-west-2      = "uswe2"
    us-gov-west-1  = "ugwe2"
    ca-central-1   = "cace1"
    eu-west-1      = "euwe1"
    eu-west-2      = "euwe2"
    eu-central-1   = "euce1"
    eu-south-1     = "euso1"
    ap-southeast-1 = "apse1"
    ap-southeast-2 = "apse2"
    ap-south-1     = "apso1"
    ap-northeast-1 = "apne1"
    ap-northeast-2 = "apne2"
    sa-east-1      = "saea1"
    cn-north-1     = "cnno1"
  }
  collaborator_map = {
    for k_acct, v_acct in local.collaborator_raw_map : k_acct => {
      aws_account_id = v_acct.aws_account_id
      root_user      = "arn:${local.iam_partition}:iam::${v_acct.aws_account_id}:root"
      user_list      = v_acct.user_list
      user_arn_list  = [for user in v_acct.user_list : "arn:${local.iam_partition}:iam::${v_acct.aws_account_id}:user/${user}"]
    }
  }
  config_name          = replace("config_${var.std_var.app}_${var.std_var.env}_${local.aws_region_abbreviation}", "-", "_")
  config_name_suffix   = "_${local.config_name}"
  iam_partition        = var.std_var.iam_partition == null ? "aws" : var.std_var.iam_partition
  resource_name        = replace("${local.resource_name_prefix}${local.resource_name_suffix}", "--", "-")
  resource_name_prefix = replace("${var.std_var.app}-", "_", "-")
  resource_name_suffix = replace("-${var.std_var.env}${local.workspace_suffix}-${local.aws_region_abbreviation}", "_", "-")
  service_resource_access_action = {
    for k_service, resource_map in local.service_resource_access_action_raw : k_service => {
      for k_resource, action_map in resource_map : k_resource => {
        public_read       = [for action in action_map.public_read : "${k_service}:${action}"]
        read              = [for action in distinct(concat(action_map.public_read, action_map.read)) : "${k_service}:${action}"]
        public_read_write = [for action in distinct(concat(action_map.public_read, action_map.public_write)) : "${k_service}:${action}"]
        read_write        = [for action in distinct(concat(action_map.public_read, action_map.read, action_map.public_write, action_map.write)) : "${k_service}:${action}"]
        public_write      = [for action in action_map.public_write : "${k_service}:${action}"]
        write             = [for action in distinct(concat(action_map.public_write, action_map.write)) : "${k_service}:${action}"]
      }
    }
  }
  tags = merge(
    merge(
      {
        Name = local.resource_name
      },
      var.tags
    ),
    {
      application    = var.std_var.app,
      environment    = var.std_var.env,
      "tf.workspace" = terraform.workspace
    }
  )
  workspace_suffix = terraform.workspace == "default" ? "" : "-${terraform.workspace}"
}
