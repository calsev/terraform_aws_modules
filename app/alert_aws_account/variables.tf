variable "alert_level_map" {
  type = map(object({
    email_address_list = optional(list(string))
  }))
  default = {
    general_high = {
      email_address_list = null
    }
    general_low = {
      email_address_list = null
    }
    general_medium = {
      email_address_list = null
    }
  }
  description = "These are user-defined here but must be consistent throughout the codebase"
}

variable "alert_email_address_list_default" {
  type    = list(string)
  default = []
}

variable "change_level_map" {
  type = map(object({
    email_address_list = optional(list(string))
  }))
  default = {
    critical = {
      email_address_list = null
    }
    high = {
      email_address_list = null
    }
    low = {
      email_address_list = null
    }
    medium = {
      email_address_list = null
    }
  }
  description = "Keys are fixed and map to the severity level of the security control for monitoring each change"
}

variable "change_email_address_list_default" {
  type        = list(string)
  default     = null
  description = "Defaults to alert_email_address_list_default."
}

variable "encrypt_trail_with_kms" {
  type    = bool
  default = true
}

variable "s3_data_map" {
  type = map(object({
    name_effective = string
  }))
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

variable "trail_log_bucket_key" {
  type = string
}
