variable "api_map" {
  type = map(object({
    auth_cognito_client_app_key_default = optional(string)
    auth_cognito_pool_key_default       = optional(string)
    auth_lambda_key_default             = optional(string)
    auth_map = optional(map(object({
      cognito_client_app_key = optional(string)
      cognito_pool_key       = optional(string)
      lambda_key             = optional(string)
    })))
    auth_request_iam_role_arn_default = optional(string)
    cors_allow_credentials            = optional(bool)
    cors_allow_headers                = optional(list(string))
    cors_allow_methods                = optional(list(string))
    cors_allow_origins                = optional(list(string))
    cors_enabled                      = optional(bool)
    cors_expose_headers               = optional(list(string))
    cors_max_age                      = optional(number)
    disable_execute_endpoint          = optional(bool)
    integration_iam_role_arn_default  = optional(string)
    integration_map = map(object({
      http_method          = optional(string) # Ignored for sqs, states
      iam_role_arn         = optional(string)
      passthrough_behavior = optional(string)
      request_parameters   = optional(map(string)) # Defaults provided for sqs, states
      route_map = optional(map(object({            # Key is "Method path", e.g. "GET /pet", or "$default", defaults to { "integration_route_method_default /route_key" = {} }
        authorization_scopes = optional(list(string))
        authorization_type   = optional(string)
        authorizer_id        = optional(string)
        operation_name       = optional(string)
        auth_key             = optional(string)
      })))
      service         = optional(string)
      target_arn      = optional(string) # Used for states, ignored for lambda, sqs
      target_uri      = optional(string) # Used for lambda, sqs, ignored for states
      timeout_seconds = optional(number)
      type            = optional(string)
      vpc_link_id     = optional(string)
    }))
    integration_route_auth_key_default = optional(string)
    integration_route_method_default   = optional(string) # Used only for default route maps
    integration_service_default        = optional(string)
    name_infix                         = optional(bool)
    stage_map = map(object({ # Settings are applied uniformly to all routes for a stage
      detailed_metrics_enabled = optional(bool)
      enable_default_route     = optional(bool)
      log_group_arn            = string
      throttling_burst_limit   = optional(number)
      throttling_rate_limit    = optional(number)
    }))
    version = optional(string)
  }))
}

variable "api_auth_map_default" {
  type = map(object({
    cognito_client_app_key = optional(string)
    cognito_pool_key       = optional(string)
    lambda_key             = optional(string)
  }))
  default = {}
}

variable "api_cors_allow_credentials_default" {
  type    = bool
  default = null
}

variable "api_cors_allow_headers_default" {
  type    = list(string)
  default = ["*"]
}

variable "api_cors_allow_methods_default" {
  type    = list(string)
  default = ["GET", "HEAD", "OPTIONS", "POST"]
}

variable "api_cors_allow_origins_default" {
  type    = list(string)
  default = ["*"] # TODO: Default to mapped domains
}

variable "api_cors_enabled_default" {
  type        = bool
  default     = false
  description = "CORS at the API level does a few things: Auto-reply to OPTIONS requests (no route required), ignore CORS headers from integrations, see https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api-cors.html"
}

variable "api_cors_expose_headers_default" {
  type    = list(string)
  default = ["*"]
}

variable "api_cors_max_age_default" {
  type    = number
  default = null
}

variable "api_disable_execute_endpoint_default" {
  type    = bool
  default = false
}

variable "api_name_infix_default" {
  type    = bool
  default = true
}

variable "api_version_default" {
  type    = string
  default = "1"
}

variable "cognito_data_map" {
  type = map(object({
    client_app_map = map(object({
      client_app_id = string
    }))
    user_pool_endpoint = string
  }))
  default     = {}
  description = "Must be provided if any API uses a cognito authorizer"
}

variable "dns_data" {
  type = object({
    domain_to_dns_zone_map = map(object({
      dns_zone_id = string
    }))
    region_domain_cert_map = map(map(object({
      arn = string
    })))
    ttl_map = object({
      challenge = number
    })
  })
  default     = null
  description = "Must be provided if any stage has a DNS mapping"
}

variable "domain_map" {
  type = map(object({
    validation_domain = optional(string)
  }))
  default = {}
}

variable "domain_validation_domain_default" {
  type    = string
  default = null
}

variable "lambda_data_map" {
  type = map(object({
    invoke_arn = string
  }))
  default     = {}
  description = "Must be provided if any API uses a Lambda authorizer"
}

variable "std_map" {
  type = object({
    access_title_map               = map(string)
    aws_account_id                 = string
    aws_region_name                = string
    iam_partition                  = string
    name_replace_regex             = string
    resource_name_prefix           = string
    resource_name_suffix           = string
    service_resource_access_action = map(map(map(list(string))))
    tags                           = map(string)
  })
}
