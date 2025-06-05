resource "aws_organizations_organization" "org" {
  for_each                      = local.lx_map
  aws_service_access_principals = each.value.aws_service_access_principal_list
  enabled_policy_types          = each.value.enabled_policy_type_list
  feature_set                   = each.value.feature_set
}

resource "aws_iam_organizations_features" "feature" {
  for_each         = local.lx_map
  enabled_features = each.value.iam_feature_list
}
