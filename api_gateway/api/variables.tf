variable "api_map" {
  type = map(object({
    cors_allow_credentials   = optional(bool)
    cors_allow_headers       = optional(list(string))
    cors_allow_methods       = optional(list(string))
    cors_allow_origins       = optional(list(string))
    cors_enabled             = optional(bool)
    cors_expose_headers      = optional(list(string))
    cors_max_age             = optional(number)
    disable_execute_endpoint = optional(bool)
    name_append              = optional(string)
    name_include_app_fields  = optional(bool)
    name_infix               = optional(bool)
    name_prefix              = optional(string)
    name_prepend             = optional(string)
    name_suffix              = optional(string)
    version                  = optional(string)
  }))
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

variable "api_name_include_app_fields_default" {
  type    = bool
  default = true
}

variable "api_name_infix_default" {
  type    = bool
  default = true
}

variable "api_version_default" {
  type    = string
  default = "1"
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
