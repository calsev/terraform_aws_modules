locals {
  output_data = merge(
    module.backup_iam.data,
    module.batch_iam.data,
    module.bedrock_iam.data,
    module.ec2_iam.data,
    module.ecr_iam.data,
    module.ecs_iam.data,
    module.lambda_iam.data,
    module.rds_iam.data,
    module.support_iam.data,
    module.users.data,
    {
      account         = module.account.data
      key_pair_map    = module.key_pair.data
      organization    = module.organization.data
      password_policy = module.password_policy.data
    }
  )
  std_var = {
    app             = "inf-iam"
    aws_region_name = "us-west-2"
    env             = "prod"
  }
}
