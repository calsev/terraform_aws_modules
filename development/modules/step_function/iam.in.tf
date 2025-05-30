module "machine_role" {
  source                               = "../iam/role/step_function"
  for_each                             = local.lx_map
  log_data                             = module.log.data[each.key]
  name                                 = "${each.key}_states"
  {{ iam.role_map_item() }}
  std_map                              = var.std_map
}

{{ iam.policy_identity_ar_type(suffix="step_function/machine", policy_name="machine_policy") }}
