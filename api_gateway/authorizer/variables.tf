variable "api_map" {
  type = map(object({
    api_id                              = string
    auth_cognito_client_app_key_default = optional(string)
    auth_cognito_pool_key_default       = optional(string)
    auth_lambda_key_default             = optional(string)
    auth_map = optional(map(object({
      cognito_client_app_key          = optional(string)
      cognito_pool_key                = optional(string)
      identity_source_list            = optional(list(string))
      lambda_key                      = optional(string)
      request_cache_ttl_s             = optional(number)
      request_iam_role_arn            = optional(string)
      request_payload_format_version  = optional(string)
      request_simple_response_enabled = optional(bool)
    })))
    auth_request_iam_role_arn_default = optional(string) # Ignored for JWT authorizers
    name_append                       = optional(string)
    name_include_app_fields           = optional(bool)
    name_infix                        = optional(bool)
    name_prefix                       = optional(string)
    name_prepend                      = optional(string)
    name_suffix                       = optional(string)
  }))
}

variable "auth_identity_source_list_default" {
  type    = list(string)
  default = ["$request.header.Authorization"]
}

variable "auth_map_default" {
  type = map(object({
    cognito_client_app_key          = optional(string)
    cognito_pool_key                = optional(string)
    identity_source_list            = optional(list(string))
    lambda_key                      = optional(string)
    request_cache_ttl_s             = optional(number)
    request_iam_role_arn            = optional(string)
    request_payload_format_version  = optional(string)
    request_simple_response_enabled = optional(bool)
  }))
  default = {}
}

variable "auth_request_cache_ttl_s_default" {
  type        = number
  default     = 300
  description = "Set to 0 to disable caching. Disabled for JWT authorizers."
  validation {
    condition     = 0 <= var.auth_request_cache_ttl_s_default && var.auth_request_cache_ttl_s_default <= 3600
    error_message = "Invalid cache TTL"
  }
}

variable "auth_request_payload_format_version_default" {
  type        = string
  default     = "2.0"
  description = "Ignored for JWT authorizers"
  validation {
    condition     = contains(["1.0", "2.0"], var.auth_request_payload_format_version_default)
    error_message = "Invalid authorizer format"
  }
}

variable "auth_request_simple_response_enabled_default" {
  type        = bool
  default     = true
  description = "Ignored for JWT authorizers"
}

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
  description = "Must be provided if any API uses a Cognito authorizer"
}

variable "lambda_data_map" {
  type = map(object({
    invoke_arn = string
  }))
  default     = {}
  description = "Must be provided if any API uses a Lambda authorizer"
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
