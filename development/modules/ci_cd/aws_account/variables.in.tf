variable "bucket_lifecycle_expiration_days" {
  type    = number
  default = 7
}

variable "log_public_enabled" {
  type        = bool
  default     = false
  description = "If true, a public log group will be created"
}

variable "log_retention_days" {
  type    = number
  default = 7
}

variable "bucket_log_target_bucket_name_default" {
  type    = string
  default = null
}

variable "server_type_to_secret" {
  type = map(object({
    secret_key     = optional(string)
    ssm_param_name = optional(string)
    sm_secret_name = optional(string)
  }))
  description = "Only one credential is allowed per server type per region. Sever types are BITBUCKET, GITHUB, GITHUB_ENTERPRISE. Token for github can be created at https://github.com/settings/tokens. The token must have permission repo, repo:status, admin:repo_hook. See https://docs.aws.amazon.com/codebuild/latest/userguide/access-tokens.html"
}

{{ std.map() }}
