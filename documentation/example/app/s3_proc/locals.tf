locals {
  bucket_key   = "source"
  compute_name = "comp"
  job_name     = "job"
  output_data = {
    batch  = module.batch.data
    bucket = module.s3.data
    iam = {
      policy = {
        param_secret_temp = module.param_secret_temp.data
      }
      role = {
        job_container = module.job_role.data
      }
    }
    job     = module.job.data
    trigger = module.s3_trigger.data
  }
  std_var = {
    app             = "app-s3proc"
    aws_region_name = "us-west-2"
    env             = "prod"
  }
}
