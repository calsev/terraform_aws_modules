module "this_policy" {
  source      = "../../../../../iam/policy/identity/access_resource"
  access_list = var.access_list
  name        = var.name
  name_infix  = var.name_infix
  name_prefix = var.name_prefix
  resource_map = {
    state_machine = [local.machine_arn]
  }
  service_name = "states"
  std_map      = var.std_map
}
