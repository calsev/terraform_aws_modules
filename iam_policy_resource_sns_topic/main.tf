module "this_policy" {
  source       = "../iam_policy_resource_access_resource"
  service_name = local.service_name
  sid_map      = local.sid_map
  std_map      = var.std_map
}
