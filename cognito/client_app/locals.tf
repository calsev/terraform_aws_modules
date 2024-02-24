module "name_map" {
  source   = "../../name_map"
  name_map = local.l2_map
  std_map  = var.std_map
}

locals {
  l1_list = flatten([
    for k_pool, v_pool in var.pool_map : [
      for k_app, v_app in v_pool.client_app_map : merge(
        {
          for k, v in v_pool : k => v if !contains(["client_app_map"], k)
        },
        v_app,
        {
          access_token_validity_minutes                 = v_app.access_token_validity_minutes == null ? var.client_access_token_validity_minutes_default : v_app.access_token_validity_minutes
          auth_session_validity_minutes                 = v_app.auth_session_validity_minutes == null ? var.client_auth_session_validity_minutes_default : v_app.auth_session_validity_minutes
          callback_url_list                             = v_app.callback_url_list == null ? var.client_callback_url_list_default : v_app.callback_url_list
          default_redirect_uri                          = v_app.default_redirect_uri == null ? var.client_default_redirect_uri_default : v_app.default_redirect_uri
          enable_propagate_additional_user_context_data = v_app.enable_propagate_additional_user_context_data == null ? var.client_enable_propagate_additional_user_context_data_default : v_app.enable_propagate_additional_user_context_data
          enable_token_revocation                       = v_app.enable_token_revocation == null ? var.client_enable_token_revocation_default : v_app.enable_token_revocation
          explicit_auth_flow_list                       = v_app.explicit_auth_flow_list == null ? var.client_explicit_auth_flow_list_default : v_app.explicit_auth_flow_list
          generate_secret                               = v_app.generate_secret == null ? var.client_generate_secret_default : v_app.generate_secret
          id_token_validity_minutes                     = v_app.id_token_validity_minutes == null ? var.client_id_token_validity_minutes_default : v_app.id_token_validity_minutes
          k_app                                         = k_app
          k_all                                         = "${k_pool}_${k_app}"
          k_pool                                        = k_pool
          logout_url_list                               = v_app.logout_url_list == null ? var.client_logout_url_list_default : v_app.logout_url_list
          oath_flow_allowed_list                        = v_app.oath_flow_allowed_list == null ? var.client_oath_flow_allowed_list_default : v_app.oath_flow_allowed_list
          oath_flow_enabled                             = v_app.oath_flow_enabled == null ? var.client_oath_flow_enabled_default : v_app.oath_flow_enabled
          oath_scope_list                               = v_app.oath_scope_list == null ? var.client_oath_scope_list_default : v_app.oath_scope_list
          read_attribute_list                           = v_app.read_attribute_list == null ? var.client_read_attribute_list_default : v_app.read_attribute_list
          refresh_token_validity_hours                  = v_app.refresh_token_validity_hours == null ? var.client_refresh_token_validity_hours_default : v_app.refresh_token_validity_hours
          supported_identity_provider_list              = v_app.supported_identity_provider_list == null ? var.client_supported_identity_provider_list_default : v_app.supported_identity_provider_list
          write_attribute_list                          = v_app.write_attribute_list == null ? var.client_write_attribute_list_default : v_app.write_attribute_list
        }
      )
    ]
  ])
  l2_map = {
    for v in local.l1_list : v.k_all => v
  }
  lx_map = {
    for k, v in local.l2_map : k => merge(v, module.name_map.data[k])
  }
  output_data = {
    for k_pool, v_pool in var.pool_map : k_pool => merge(
      v_pool,
      {
        client_app_map = {
          for k_all, v_all in local.lx_map : v_all.k_app => merge(
            {
              for k, v in v_all : k => v if !contains(["k_all", "k_app", "k_api"], k)
            },
            {
              client_app_id = aws_cognito_user_pool_client.this_client[k_all].id
            },
          )
        }
      }
    )
  }
}
