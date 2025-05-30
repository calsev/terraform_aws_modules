module "ecr_mirror_policy" {
  source                     = "../../iam/policy/identity/ecr"
  policy_access_list_default = ["read_write"]
  policy_map = {
    ecr_mirror = {
      repo_name = "*"
    }
  }
  std_map = var.std_map
}
