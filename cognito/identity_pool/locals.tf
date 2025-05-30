module "name_map" {
  source                          = "../../name_map"
  name_append_default             = var.name_append_default
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_map                        = local.l0_map
  name_prefix_default             = var.name_prefix_default
  name_prepend_default            = var.name_prepend_default
  name_regex_allow_list           = var.name_regex_allow_list
  name_suffix_default             = var.name_suffix_default
  std_map                         = var.std_map
}

locals {
  create_tag_0_list = flatten([
    for k, v in local.lx_map : [
      for k_p, v_p in v.cognito_provider_map : merge(v, v_p, {
        identity_pool_id = aws_cognito_identity_pool.this_pool[k].id
        k_all            = "${k}_${k_p}"
      })
    ]
  ])
  create_tag_x_map = {
    for v in local.create_tag_0_list : v.k_all => v
  }
  l0_map = {
    for k, v in var.pool_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      classic_flow_enabled               = v.classic_flow_enabled == null ? var.pool_classic_flow_enabled_default : v.classic_flow_enabled
      cognito_provider_map               = v.cognito_provider_map == null ? var.pool_cognito_provider_map_default : v.cognito_provider_map
      login_provider_map                 = v.login_provider_map == null ? var.pool_login_provider_map_default : v.login_provider_map
      openid_connect_provider_arn_list   = v.openid_connect_provider_arn_list == null ? var.pool_openid_connect_provider_arn_list_default : v.openid_connect_provider_arn_list
      saml_provider_arn_list             = v.saml_provider_arn_list == null ? var.pool_saml_provider_arn_list_default : v.saml_provider_arn_list
      unauthenticated_identities_allowed = v.unauthenticated_identities_allowed == null ? var.pool_unauthenticated_identities_allowed_default : v.unauthenticated_identities_allowed
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      cognito_provider_map = {
        for k_p, v_p in local.l1_map[k].cognito_provider_map : k_p => merge(v_p, {
          client_app_key                      = v_p.client_app_key == null ? var.pool_cognito_provider_client_app_key_default == null ? k_p : var.pool_cognito_provider_client_app_key_default : v_p.client_app_key
          principal_tag_to_provider_claim_map = v_p.principal_tag_to_provider_claim_map == null ? var.pool_cognito_provider_principal_tag_to_provider_claim_map_default : v_p.principal_tag_to_provider_claim_map
          user_pool_key                       = v_p.user_pool_key == null ? var.pool_cognito_provider_user_pool_key_default == null ? k_p : var.pool_cognito_provider_user_pool_key_default : v_p.user_pool_key
          server_side_token_check_enabled     = v_p.server_side_token_check_enabled == null ? var.pool_cognito_provider_server_side_token_check_enabled_default : v_p.server_side_token_check_enabled
        })
      }
    }
  }
  l3_map = {
    for k, v in local.l0_map : k => {
      cognito_provider_map = {
        for k_p, v_p in local.l2_map[k].cognito_provider_map : k_p => merge(v_p, {
          client_app_id                         = var.cognito_data_map[v_p.user_pool_key].user_pool_client.client_app_map[v_p.client_app_key].client_app_id
          principal_tag_default_mapping_enabled = length(v_p.principal_tag_to_provider_claim_map) == 0 ? v_p.principal_tag_default_mapping_enabled == null ? var.pool_cognito_provider_principal_tag_default_mapping_enabled_default : v_p.principal_tag_default_mapping_enabled : false
          user_pool_endpoint                    = var.cognito_data_map[v_p.user_pool_key].user_pool_endpoint
        })
      }
    }
  }
  l4_map = {
    for k, v in local.l0_map : k => {
      cognito_provider_map = {
        for k_p, v_p in local.l3_map[k].cognito_provider_map : k_p => merge(v_p, {
          principal_tag_to_provider_claim_map = v_p.principal_tag_default_mapping_enabled ? {
            # This is a bit circular, but a permament difference is shown if these are not set
            client   = "aud"
            username = "sub"
          } : v_p.principal_tag_to_provider_claim_map
        })
      }
    }
  }
  lx_map = {
    for k, _ in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k], local.l3_map[k], local.l4_map[k])
  }
  output_data = {
    for k, v in local.lx_map : k => merge(
      {
        for k_attr, v_attr in v : k_attr => v_attr if !contains([], k_attr)
      },
      {
        identity_pool_arn = aws_cognito_identity_pool.this_pool[k].arn
        identity_pool_id  = aws_cognito_identity_pool.this_pool[k].id
      }
    )
  }
}
