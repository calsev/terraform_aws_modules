locals {
  output_data = {
    ecr_mirror = module.ecr_repo_mirror.data
  }
  std_var = {
    app             = "inf-task"
    aws_region_name = "us-west-2"
    env             = "prod"
  }
}
