variable "organization_map" {
  type = map(object({
    aws_service_access_principal_list = optional(list(string))
    enabled_policy_type_list          = optional(list(string))
    feature_set                       = optional(string)
    iam_feature_list                  = optional(list(string))
    {{ name.var_item() }}
  }))
}

{{ name.var() }}

variable "organization_aws_service_access_principal_list_default" {
  type = list(string)
  default = [
    "account.amazonaws.com",
    "aws-artifact-account-sync.amazonaws.com",
    "cost-optimization-hub.bcm.amazonaws.com",
    "iam.amazonaws.com",
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

{{ std.map() }}
