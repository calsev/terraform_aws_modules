module "policy" {
  source  = "../iam_policy_assume_role"
  sid_map = local.sid_map
}
