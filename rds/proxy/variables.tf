variable "db_data_map" {
  type = map(object({
    name_effective = string
  }))
}

variable "proxy_map" {
  type = map(object({
    auth_client_password_type = optional(string)
    auth_iam_required         = optional(bool)
    auth_sm_secret_arn        = string
    auth_username             = optional(string)
    debug_logging_enabled     = optional(bool)
    engine_family             = optional(string)
    iam_role_arn              = optional(string)
    idle_client_timeout       = optional(number)
    target_group_map = map(object({ # Currently only a single target group is supported per proxy
      connection_borrow_timeout_seconds = optional(number)
      target_map = map(object({
        db_key = optional(string) # Defaults to target key
      }))
      init_query                  = optional(string)
      max_target_percent          = optional(number)
      max_idle_percent            = optional(number)
      session_pinning_filter_list = optional(list(string))
    }))
    tls_required                = optional(bool)
    vpc_az_key_list             = optional(list(string))
    vpc_key                     = optional(string)
    vpc_security_group_key_list = optional(list(string))
    vpc_segment_key             = optional(string)
  }))
}

variable "proxy_auth_client_password_type_default" {
  type    = string
  default = null
  validation {
    condition     = contains(["MYSQL_NATIVE_PASSWORD", "POSTGRES_SCRAM_SHA_256", "POSTGRES_MD5", "SQL_SERVER_AUTHENTICATION"], var.proxy_auth_client_password_type_default)
    error_message = "Invalid password type"
  }
}

variable "proxy_auth_iam_required_default" {
  type        = bool
  default     = false
  description = "IAM auth is exclusive, either required or disabled"
}

variable "proxy_auth_username_default" {
  type        = string
  default     = null
  description = "This can also be fetched from secret.username"
}

variable "proxy_debug_logging_enabled_default" {
  type        = bool
  default     = false
  description = "Logs contain full text of queries, so use with precision"
}

variable "proxy_engine_family_default" {
  type    = string
  default = null
  validation {
    condition     = contains(["MYSQL", "POSTGRESQL", "SQLSERVER"], var.proxy_engine_family_default)
    error_message = "Invalid engine family"
  }
}

variable "proxy_iam_role_arn_default" {
  type    = string
  default = null
}

variable "proxy_idle_client_timeout_default" {
  type    = number
  default = null
}

variable "proxy_target_connection_borrow_timeout_seconds_default" {
  type    = number
  default = 120
}

variable "proxy_target_init_query_default" {
  type    = string
  default = null
}

variable "proxy_target_max_target_percent_default" {
  type    = number
  default = 100
}

variable "proxy_target_max_idle_percent_default" {
  type    = number
  default = 50
}

variable "proxy_target_session_pinning_filter_list_default" {
  type    = list(string)
  default = []
}

variable "proxy_tls_required_default" {
  type    = bool
  default = false
}

variable "std_map" {
  type = object({
    name_replace_regex   = string
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}

variable "vpc_az_key_list_default" {
  type    = list(string)
  default = ["a", "b"]
}

variable "vpc_data_map" {
  type = map(object({
    security_group_id_map = map(string)
    segment_map = map(object({
      route_public  = bool
      subnet_id_map = map(string)
    }))
    vpc_assign_ipv6_cidr = bool
    vpc_id               = string
  }))
}

variable "vpc_key_default" {
  type    = string
  default = null
}

variable "vpc_security_group_key_list_default" {
  type = list(string)
  default = [
    "world_all_out",
    "internal_mysql_in",
    "internal_postgres_in",
  ]
}

variable "vpc_segment_key_default" {
  type    = string
  default = "internal"
}
