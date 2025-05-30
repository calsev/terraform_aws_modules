variable "detector_map" {
  type = map(object({
    feature_map = optional(map(object({
      add_on_list = optional(list(object({
        enabled = optional(bool, true)
        name    = string
      })), [])
      enabled = optional(bool, true)
    })))
    finding_publishing_frequency = optional(string)
    is_enabled                   = optional(bool)
    name_append                  = optional(string)
    name_include_app_fields      = optional(bool)
    name_infix                   = optional(bool)
    name_prefix                  = optional(string)
    name_prepend                 = optional(string)
    name_suffix                  = optional(string)
  }))
}

variable "detector_feature_map_default" {
  type = map(object({
    add_on_list = optional(list(object({
      enabled = optional(bool, true) # Ignored if the feature is not enabled
      name    = string
    })), [])
    enabled = optional(bool, true)
  }))
  default = {
    EBS_MALWARE_PROTECTION = {
      add_on_list = []
      enabled     = true
    }
    EKS_AUDIT_LOGS = {
      add_on_list = []
      enabled     = true
    }
    LAMBDA_NETWORK_LOGS = {
      add_on_list = []
      enabled     = true
    }
    RDS_LOGIN_EVENTS = {
      add_on_list = []
      enabled     = true
    }
    RUNTIME_MONITORING = {
      add_on_list = [
        # Order here is peculiar to provider
        {
          enabled = true
          name    = "EKS_ADDON_MANAGEMENT"
        },
        {
          enabled = true
          name    = "ECS_FARGATE_AGENT_MANAGEMENT"
        },
        {
          enabled = true
          name    = "EC2_AGENT_MANAGEMENT"
        },
      ]
      enabled = true
    }
    S3_DATA_EVENTS = {
      add_on_list = []
      enabled     = true
    }
  }
}

variable "detector_finding_publishing_frequency_default" {
  type    = string
  default = "SIX_HOURS"
  validation {
    condition     = contains(["FIFTEEN_MINUTES", "ONE_HOUR", "SIX_HOURS"], var.detector_finding_publishing_frequency_default)
    error_message = "Invalid finding publishing frequency"
  }
}

variable "detector_is_enabled_default" {
  type    = bool
  default = true
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
