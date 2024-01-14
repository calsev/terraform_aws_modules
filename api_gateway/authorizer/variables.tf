variable "api_map" {
  type = map(object({
    api_id = string
    auth_map = map(object({
      authorizer_type                 = optional(string)
      identity_source_list            = optional(list(string))
      jwt_audience_list               = optional(list(string))
      jwt_issuer                      = optional(string)
      request_authorizer_uri          = optional(string)
      request_cache_ttl_s             = optional(number)
      request_iam_role_arn            = optional(string)
      request_payload_format_version  = optional(string)
      request_simple_response_enabled = optional(bool)
    }))
  }))
}

variable "auth_api_id_default" {
  type    = string
  default = null
}

variable "auth_authorizer_type_default" {
  type    = string
  default = "JWT"
  validation {
    condition     = contains(["JWT", "REQUEST"], var.auth_authorizer_type_default)
    error_message = "Invalid authorizer type"
  }
}

variable "auth_identity_source_list_default" {
  type    = list(string)
  default = ["$request.header.Authorization"]
}

variable "auth_jwt_audience_list_default" {
  type    = list(string)
  default = null
}

variable "auth_jwt_issuer_default" {
  type    = string
  default = null
}

variable "auth_request_authorizer_uri_default" {
  type        = string
  default     = null
  description = "The Lambda invoke ARN. Ignored for JWT authorizers."
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

variable "auth_request_iam_role_arn_default" {
  type        = string
  default     = null
  description = "Ignored for JWT authorizers"
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

variable "std_map" {
  type = object({
    name_replace_regex   = string
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}
