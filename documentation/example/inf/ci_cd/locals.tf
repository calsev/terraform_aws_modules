locals {
  output_data = merge(
    module.ci_cd_aws.data,
    {
      code_star = module.ci_cd.data
    }
  )
  std_var = {
    app             = "inf-cicd"
    aws_region_name = "us-west-2"
    env             = "prod"
  }
}
