module "this_policy" {
  source      = "../iam_policy_role_access_resource"
  access_list = ["read", "read_write", "write"]
  name        = var.name
  name_infix  = var.name_infix
  name_prefix = var.name_prefix
  resource_map = {
    repo = [local.repo_arn]
    star = ["*"]
  }
  service_name = "ecr"
  std_map      = var.std_map
}
