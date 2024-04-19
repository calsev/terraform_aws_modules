locals {
  has_build  = length(var.build_name_list) != 0
  has_deploy = length(var.deploy_group_to_app) != 0
  output_data = merge(module.this_role.data, {
    start_build_policy = local.has_build ? module.start_build["this"].data : null
  })
}
