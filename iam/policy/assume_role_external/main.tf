module "policy" {
  source  = "../../../iam/policy/assume_role"
  sid_map = local.sid_map
}
