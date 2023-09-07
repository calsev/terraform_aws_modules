variable "bucket_lifecycle_expiration_days" {
  type    = number
  default = 14
}

variable "log_public_enabled" {
  type        = bool
  default     = false
  description = "If true, a public log group will be created"
}

variable "log_retention_days" {
  type    = number
  default = 14
}

variable "policy_create" {
  type    = bool
  default = true
}

variable "policy_name_prefix" {
  type    = string
  default = ""
}

variable "server_type_to_secret" {
  type = map(object({
    ssm_param_name = optional(string)
    sm_secret_name = optional(string)
    sm_secret_key  = optional(string)
  }))
  description = "Only one credential is allowed per server type per region. Sever types are BITBUCKET, GITHUB, GITHUB_ENTERPRISE. Token for github can be created at https://github.com/settings/tokens. The token must have permission repo, repo:status, admin:repo_hook. See https://docs.aws.amazon.com/codebuild/latest/userguide/access-tokens.html"
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
