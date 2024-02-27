locals {
  output_data = merge(module.this_role.data, {
    start_build_policy = module.start_build.data
  })
}
