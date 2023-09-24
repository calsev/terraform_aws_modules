module "this_policy" {
  source      = "../iam_policy_identity_access_resource"
  access_list = var.access_list
  name        = var.name
  name_infix  = var.name_infix
  name_prefix = var.name_prefix
  resource_map = {
    file-system = [var.efs_arn]
  }
  service_name = "elasticfilesystem"
  std_map      = var.std_map
}
