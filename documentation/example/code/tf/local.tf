locals {
  build_test_unit_common = {
    file_system_map = {
      cache = {
        location_dns  = module.efs.data["cache"].efs_dns_name
        location_path = "/" # This has to be root unless we pre-create the dir or use an access point
        mount_point   = "/root/.tflint.d/plugins"
      }
    }
    source_build_spec = "development/spec/test.yml"
  }
  output_data = {
    code_build = module.code_build.data
    code_pipe  = module.code_pipe.data
    efs        = module.efs.data
    policy = {
      deps_bucket = module.deps_bucket_policy.data
    }
    role = {
      build = module.basic_build_role.data
    }
  }
  std_var = {
    app             = "code-acs"
    aws_region_name = "us-west-2"
    env             = "com"
  }
}
