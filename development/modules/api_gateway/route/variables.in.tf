variable "api_map" {
  type = map(object({
    api_id = string
    auth_map = map(object({
      authorizer_id            = string
      route_authorization_type = string
    }))
    integration_map = map(object({
      integration_id = optional(string)
      route_map = optional(map(object({ # Key is "Method path", e.g. "GET /pet", or "$default", defaults to { "integration_route_method_default /route_key" = {} }
        auth_key             = optional(string)
        authorization_scopes = optional(list(string))
        authorization_type   = optional(string)
        authorizer_id        = optional(string)
        operation_name       = optional(string)
      })))
    }))
    integration_route_auth_key_default = optional(string)
    integration_route_method_default   = optional(string) # Used only for default route maps
  }))
}

variable "route_authorization_scopes_default" {
  type    = list(string)
  default = []
}

variable "route_authorization_type_default" {
  type        = string
  default     = "NONE"
  description = "Ignored if an auth key is provided"
  validation {
    condition     = contains(["NONE", "JWT", "AWS_IAM", "CUSTOM"], var.route_authorization_type_default)
    error_message = "Invalid authorization type"
  }
}

variable "route_authorizer_id_default" {
  type        = string
  default     = null
  description = "Ignored if an auth key is provided"
}

variable "route_integration_id_default" {
  type    = string
  default = null
}
