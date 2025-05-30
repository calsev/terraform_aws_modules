resource "aws_cognito_identity_pool" "this_pool" {
  for_each                         = local.lx_map
  allow_classic_flow               = each.value.classic_flow_enabled
  allow_unauthenticated_identities = each.value.unauthenticated_identities_allowed
  dynamic "cognito_identity_providers" {
    for_each = each.value.cognito_provider_map
    content {
      client_id               = cognito_identity_providers.value.client_app_id
      provider_name           = cognito_identity_providers.value.user_pool_endpoint
      server_side_token_check = cognito_identity_providers.value.server_side_token_check_enabled
    }
  }
  developer_provider_name      = each.value.name_effective
  identity_pool_name           = each.value.name_effective
  openid_connect_provider_arns = each.value.openid_connect_provider_arn_list
  saml_provider_arns           = each.value.saml_provider_arn_list
  supported_login_providers    = each.value.login_provider_map
  tags                         = each.value.tags
}

resource "aws_cognito_identity_pool_provider_principal_tag" "tag_to_claim" {
  for_each               = local.create_tag_x_map
  identity_pool_id       = each.value.identity_pool_id
  identity_provider_name = each.value.user_pool_endpoint
  principal_tags         = each.value.principal_tag_to_provider_claim_map
  use_defaults           = each.value.principal_tag_default_mapping_enabled
}
