variable "api_map" {
  type = map(object({
    cors_allow_credentials   = optional(bool)
    cors_allow_headers       = optional(list(string))
    cors_allow_methods       = optional(list(string))
    cors_allow_origins       = optional(list(string))
    cors_expose_headers      = optional(list(string))
    cors_max_age             = optional(number)
    disable_execute_endpoint = optional(bool)
    name_infix               = optional(bool)
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
  default = ["GET", "HEAD"] # TODO?
}

variable "api_cors_allow_origins_default" {
  type    = list(string)
  default = ["*"] # TODO: Default to mapped domains
}

variable "api_cors_expose_headers_default" {
  type    = list(string)
  default = null
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
