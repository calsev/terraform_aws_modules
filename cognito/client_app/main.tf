resource "aws_cognito_user_pool_client" "this_client" {
  for_each                             = local.lx_map
  access_token_validity                = each.value.access_token_validity_minutes
  allowed_oauth_flows                  = each.value.oath_flow_allowed_list
  allowed_oauth_flows_user_pool_client = each.value.oath_flow_enabled
  allowed_oauth_scopes                 = each.value.oath_scope_list
  #analytics_configuration TODO
  auth_session_validity                         = each.value.auth_session_validity_minutes
  callback_urls                                 = each.value.callback_url_list
  default_redirect_uri                          = each.value.default_redirect_uri
  enable_propagate_additional_user_context_data = each.value.enable_propagate_additional_user_context_data
  enable_token_revocation                       = each.value.enable_token_revocation
  explicit_auth_flows                           = each.value.explicit_auth_flow_list
  generate_secret                               = each.value.generate_secret
  id_token_validity                             = each.value.id_token_validity_minutes
  logout_urls                                   = each.value.logout_url_list
  name                                          = each.value.name_effective
  prevent_user_existence_errors                 = "ENABLED"
  read_attributes                               = each.value.read_attribute_list
  refresh_token_validity                        = each.value.refresh_token_validity_hours
  supported_identity_providers                  = each.value.supported_identity_provider_list
  token_validity_units {
    access_token  = "minutes"
    id_token      = "minutes"
    refresh_token = "hours"
  }
  user_pool_id     = each.value.user_pool_id
  write_attributes = each.value.write_attribute_list
}
