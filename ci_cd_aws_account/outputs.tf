output "data" {
  value = {
    bucket = local.bucket_data
    log    = module.build_log.data
    role = {
      build = {
        basic = module.basic_build_role.data
      }
    }
  }
}
