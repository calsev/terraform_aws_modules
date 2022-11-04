module "this_policy" {
  source      = "../iam_policy_role_access_resource"
  access_list = var.access_list
  name        = var.name
  name_infix  = var.name_infix
  name_prefix = var.name_prefix
  resource_map = {
    project = local.project_arn_list
    star    = ["*"]
  }
  service_name = "codebuild"
  std_map      = var.std_map
}
