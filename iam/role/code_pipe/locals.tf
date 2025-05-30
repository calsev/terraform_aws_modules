locals {
  create_policy_map = local.has_build ? {
    (var.name) = {
      build_project_name_list = var.build_name_list
    }
  } : {}
  has_build  = length(var.build_name_list) != 0
  has_deploy = length(var.deploy_group_to_app) != 0
  output_data = merge(module.this_role.data, {
    start_build_policy = local.has_build ? module.start_build.data[var.name] : null
  })
}
