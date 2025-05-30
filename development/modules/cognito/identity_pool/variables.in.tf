variable "cognito_data_map" {
  type = map(object({
    user_pool_client = object({
      client_app_map = map(object({
        client_app_id = string
      }))
    })
    user_pool_endpoint = string
  }))
  default     = {}
  description = "Must be provided if any pool specifies a Cognito provider"
}

{{ name.var() }}

variable "pool_map" {
  type = map(object({
    classic_flow_enabled = optional(bool)
    cognito_provider_map = optional(map(object({
      client_app_key                        = optional(string)
      principal_tag_default_mapping_enabled = optional(bool)
      principal_tag_to_provider_claim_map   = optional(map(string))
      user_pool_key                         = optional(string)
      server_side_token_check_enabled       = optional(bool)
    })))
    login_provider_map                 = optional(map(string))
    {{ name.var_item() }}
    openid_connect_provider_arn_list   = optional(list(string))
    saml_provider_arn_list             = optional(list(string))
    unauthenticated_identities_allowed = optional(bool)
  }))
}

variable "pool_classic_flow_enabled_default" {
  type    = bool
  default = false
}

variable "pool_cognito_provider_map_default" {
  type = map(object({
    client_app_key                        = optional(string)
    principal_tag_default_mapping_enabled = optional(bool)
    principal_tag_to_provider_claim_map   = optional(map(string))
    user_pool_key                         = optional(string)
    server_side_token_check_enabled       = optional(bool)
  }))
  default = {}
}

variable "pool_cognito_provider_client_app_key_default" {
  type        = string
  default     = null
  description = "Defaults to provider key"
}

variable "pool_cognito_provider_principal_tag_default_mapping_enabled_default" {
  type        = bool
  default     = true
  description = "Ignored if a custom tag map is provided"
}

variable "pool_cognito_provider_principal_tag_to_provider_claim_map_default" {
  type    = map(string)
  default = {}
}

variable "pool_cognito_provider_user_pool_key_default" {
  type        = string
  default     = null
  description = "Defaults to provider key"
}

variable "pool_cognito_provider_server_side_token_check_enabled_default" {
  type    = bool
  default = false
}

variable "pool_login_provider_map_default" {
  type        = map(string)
  default     = {}
  description = "Map of hostname to provider client ID"
}

variable "pool_openid_connect_provider_arn_list_default" {
  type    = list(string)
  default = []
}

variable "pool_saml_provider_arn_list_default" {
  type    = list(string)
  default = []
}

variable "pool_unauthenticated_identities_allowed_default" {
  type    = bool
  default = false
}

{{ std.map() }}
