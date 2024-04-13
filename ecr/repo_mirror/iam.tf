module "ecr_mirror_policy" {
  source      = "../../iam/policy/identity/ecr"
  access_list = ["read_write"]
  name        = var.task_name
  repo_name   = "*"
  std_map     = var.std_map
}

