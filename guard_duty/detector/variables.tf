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
    name_append                  = optional(bool)
    name_include_app_fields      = optional(bool)
    name_infix                   = optional(bool)
    name_prepend                 = optional(bool)
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
  description = "If true, the Terraform project context will be included in the name"
}

variable "name_infix_default" {
  type    = bool
  default = true
}

variable "name_prepend_default" {
  type        = string
  default     = ""
  description = "Prepended before key"
}

variable "std_map" {
  type = object({
    name_replace_regex   = string
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}
