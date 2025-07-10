variable "organization_map" {
  type = map(object({
    aws_service_access_principal_list = optional(list(string))
    enabled_policy_type_list          = optional(list(string))
    feature_set                       = optional(string)
    iam_feature_list                  = optional(list(string))
    name_append                       = optional(string)
    name_include_app_fields           = optional(bool)
    name_infix                        = optional(bool)
    name_prefix                       = optional(string)
    name_prepend                      = optional(string)
    name_suffix                       = optional(string)
  }))
}

variable "name_append_default" {
  type        = string
  default     = ""
  description = "Appended after key"
}

variable "name_include_app_fields_default" {
  type        = bool
  default     = true
  description = "If true, standard project context will be prefixed to the name. Ignored if not name_infix."
}

variable "name_infix_default" {
  type        = bool
  default     = true
  description = "If true, standard project prefix and resource suffix will be added to the name"
}

variable "name_prefix_default" {
  type        = string
  default     = ""
  description = "Prepended before context prefix"
}

variable "name_prepend_default" {
  type        = string
  default     = ""
  description = "Prepended before key"
}

# tflint-ignore: terraform_unused_declarations
variable "name_regex_allow_list" {
  type        = list(string)
  default     = []
  description = "By default, all punctuation is replaced by -"
}

variable "name_suffix_default" {
  type        = string
  default     = ""
  description = "Appended after context suffix"
}

variable "organization_aws_service_access_principal_list_default" {
  type = list(string)
  default = [
    "account.amazonaws.com",
    "aws-artifact-account-sync.amazonaws.com",
    "cost-optimization-hub.bcm.amazonaws.com",
    "iam.amazonaws.com",
    "sso.amazonaws.com",
  ]
}

variable "organization_enabled_policy_type_list_default" {
  type    = list(string)
  default = []
}

variable "organization_feature_set_default" {
  type        = string
  default     = "ALL"
  description = "Changing this from ALL disables several features"
  validation {
    condition     = contains(["ALL", "CONSOLIDATED_BILLING"], var.organization_feature_set_default)
    error_message = "Invalid feature set"
  }
}

variable "organization_iam_feature_list_default" {
  type = list(string)
  default = [
    "RootCredentialsManagement",
    "RootSessions"
  ]
  validation {
    condition     = length(setsubtract(toset(var.organization_iam_feature_list_default), toset(["RootCredentialsManagement", "RootSessions"]))) == 0
    error_message = "Invalid feature list"
  }
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
