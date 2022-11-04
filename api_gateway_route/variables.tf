variable "api_map" {
  type = map(object({
    api_id = string
    integration_map = map(object({
      integration_id = optional(string)
      route_map = map(object({ # Key is "Method path" e.g. "GET /pet" or "$default"
        authorization_scopes = optional(list(string))
        authorization_type   = optional(string)
        authorizer_id        = optional(string)
        operation_name       = optional(string)
      }))
    }))
  }))
}

variable "route_authorization_scopes_default" {
  type    = list(string)
  default = []
}

variable "route_authorization_type_default" {
  type    = string
  default = "NONE"
  validation {
    condition     = contains(["NONE", "JWT", "AWS_IAM", "CUSTOM"], var.route_authorization_type_default)
    error_message = "Invalid authorization type"
  }
}

variable "route_authorizer_id_default" {
  type    = string
  default = null
}

variable "route_integration_id_default" {
  type    = string
  default = null
}
