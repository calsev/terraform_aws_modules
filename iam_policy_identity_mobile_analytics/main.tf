module "this_policy" {
  source       = "../iam_policy_identity_access_resource"
  access_list  = ["write"]
  name         = var.name
  name_infix   = var.name_infix
  name_prefix  = var.name_prefix
  resource_map = local.resource_map
  service_name = local.service_name
  std_map      = var.std_map
}
