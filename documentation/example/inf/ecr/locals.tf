locals {
  output_data = {
    repo_map = module.repo.data
  }
  std_var = {
    app             = "inf-ecr"
    aws_region_name = "us-west-2"
    env             = "prod"
  }
}
