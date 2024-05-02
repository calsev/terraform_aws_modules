variable "pool_map" {
  type = map(object({
    user_pool_id = string
    client_app_map = map(object({
      access_token_validity_minutes                 = optional(number)
      auth_session_validity_minutes                 = optional(number)
      callback_url_list                             = optional(list(string))
      default_redirect_uri                          = optional(string)
      enable_propagate_additional_user_context_data = optional(bool)
      enable_token_revocation                       = optional(bool)
      explicit_auth_flow_list                       = optional(list(string))
      generate_secret                               = optional(bool)
      id_token_validity_minutes                     = optional(number)
      logout_url_list                               = optional(list(string))
      oath_flow_allowed_list                        = optional(list(string))
      oath_flow_enabled                             = optional(bool)
      oath_scope_list                               = optional(list(string))
      read_attribute_list                           = optional(list(string))
      refresh_token_validity_hours                  = optional(number)
      supported_identity_provider_list              = optional(list(string))
      write_attribute_list                          = optional(list(string))
    }))
  }))
}

variable "client_access_token_validity_minutes_default" {
  type    = number
  default = 60
}

variable "client_auth_session_validity_minutes_default" {
  type    = number
  default = 3
}

variable "client_callback_url_list_default" {
  type        = list(string)
  default     = []
  description = "URLs must include scheme"
}

variable "client_default_redirect_uri_default" {
  type    = string
  default = null
}

variable "client_explicit_auth_flow_list_default" {
  type = list(string)
  default = [
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_USER_SRP_AUTH",
  ]
}

variable "client_generate_secret_default" {
  type        = bool
  default     = false
  description = "Disallows implicit grant flow (Amplify). Required for enable_propagate_additional_user_context_data and ELB integration."
}

variable "client_logout_url_list_default" {
  type    = list(string)
  default = []
}

variable "client_oath_flow_allowed_list_default" {
  type    = list(string)
  default = ["code", "implicit"]
}

variable "client_oath_flow_enabled_default" {
  type    = bool
  default = true
}

variable "client_oath_scope_list_default" {
  type    = list(string)
  default = ["email", "openid"]
}

variable "client_enable_propagate_additional_user_context_data_default" {
  type    = bool
  default = false
}

variable "client_enable_token_revocation_default" {
  type    = bool
  default = true
}

variable "client_id_token_validity_minutes_default" {
  type    = number
  default = 60
}

variable "client_read_attribute_list_default" {
  type    = list(string)
  default = null
}

variable "client_refresh_token_validity_hours_default" {
  type    = number
  default = 30
}

variable "client_supported_identity_provider_list_default" {
  type    = list(string)
  default = ["COGNITO"]
}

variable "client_write_attribute_list_default" {
  type    = list(string)
  default = null
}

variable "std_map" {
  type = object({
    aws_region_name      = string
    name_replace_regex   = string
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}
