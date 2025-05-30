variable "ci_cd_account_data" {
  type = object({
    bucket = object({
      policy = object({
        policy_map = map(object({
          iam_policy_arn = string
        }))
      })
    })
    code_star = object({
      connection = map(object({
        policy_map = map(object({
          iam_policy_arn = string
        }))
      }))
    })
    log = object({
      policy_map = map(object({
        iam_policy_arn = string
      }))
    })
    log_public = optional(object({ # Must be provided if log public access is enabled
      policy_map = map(object({
        iam_policy_arn = string
      }))
    }))
    policy = object({
      vpc_net = object({
        iam_policy_arn = string
      })
    })
  })
}

variable "code_star_connection_key" {
  type        = string
  default     = null
  description = "If provided, permission to use the connection will be attached"
}

variable "ecr_data_map" {
  type = map(object({
    policy_map = map(object({
      iam_policy_arn = string
    }))
  }))
  default     = null
  description = "Must be provided if image key is specified"
}

variable "map_policy" {
  type = object({
    image_ecr_repo_key           = optional(string) # The key of the image to build. If specified read/write for the image will be granted.
    role_policy_attach_arn_map   = optional(map(string))
    role_policy_create_json_map  = optional(map(string))
    role_policy_inline_json_map  = optional(map(string))
    role_policy_managed_name_map = optional(map(string))
    role_path                    = optional(string)
  })
  default = {
    image_ecr_repo_key           = null
    role_policy_attach_arn_map   = null
    role_policy_create_json_map  = null
    role_policy_inline_json_map  = null
    role_policy_managed_name_map = null
    role_path                    = null
  }
}

variable "max_session_duration_m" {
  type    = number
  default = null
}

variable "name" {
  type = string
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

variable "log_public_access" {
  type        = bool
  default     = false
  description = "If true, this role will add permissions for the public log"
}

variable "log_bucket_key" {
  type        = string
  default     = null
  description = "If provided, write permissions for the bucket will be added"
}

variable "role_policy_attach_arn_map_default" {
  type    = map(string)
  default = {}
}

variable "role_policy_create_json_map_default" {
  type    = map(string)
  default = {}
}

variable "role_policy_inline_json_map_default" {
  type    = map(string)
  default = {}
}

variable "role_policy_managed_name_map_default" {
  type        = map(string)
  default     = {}
  description = "The short identifier of the managed policy, the part after 'arn:<iam_partition>:iam::aws:policy/'"
}

variable "role_path_default" {
  type    = string
  default = null
}

variable "s3_data_map" {
  type = map(object({
    policy = object({
      policy_map = map(object({
        iam_policy_arn = string
      }))
    })
  }))
  default     = null
  description = "Must be provided if a log bucket key is specified"
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

variable "vpc_access" {
  type        = bool
  default     = false
  description = "If true, this role will add permissions for VPC networking"
}
