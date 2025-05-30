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

variable "name_append_default" {
  type        = string
  default     = ""
  description = "Appended after key"
}

variable "name_include_app_fields_default" {
  type        = bool
  default     = true
  description = "If true, standard project context will be prefixed to the name. Ignored if not name_infix."
}

variable "name_infix_default" {
  type        = bool
  default     = true
  description = "If true, standard project prefix and resource suffix will be added to the name"
}

variable "name_prefix_default" {
  type        = string
  default     = ""
  description = "Prepended before context prefix"
}

variable "name_prepend_default" {
  type        = string
  default     = ""
  description = "Prepended before key"
}

# tflint-ignore: terraform_unused_declarations
variable "name_regex_allow_list" {
  type        = list(string)
  default     = []
  description = "By default, all punctuation is replaced by -"
}

variable "name_suffix_default" {
  type        = string
  default     = ""
  description = "Appended after context suffix"
}

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
    name_append                        = optional(string)
    name_include_app_fields            = optional(bool)
    name_infix                         = optional(bool)
    name_prefix                        = optional(string)
    name_prepend                       = optional(string)
    name_suffix                        = optional(string)
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

variable "std_map" {
  type = object({
    access_title_map               = map(string)
    aws_account_id                 = string
    aws_region_name                = string
    config_name                    = string
    env                            = string
    iam_partition                  = string
    name_replace_regex             = string
    resource_name_prefix           = string
    resource_name_suffix           = string
    service_resource_access_action = map(map(map(list(string))))
    tags                           = map(string)
  })
}
