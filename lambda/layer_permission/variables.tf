variable "permission_map" {
  type = map(object({
    aws_account_id_list = optional(list(string))
    layer_version_arn   = string
    skip_destroy        = optional(bool)
  }))
}

variable "permission_aws_account_id_list_default" {
  type        = list(string)
  default     = null
  description = "Accounts granted lambda:GetLayerVersion. Defaults to the current account."
}

variable "permission_skip_destroy_default" {
  type        = bool
  default     = true
  description = "If true, a grant is kept when its layer version is replaced, so the kept old version stays usable"
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
