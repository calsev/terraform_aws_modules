variable "ci_cd_account_data" {
  type = object({
    bucket = object({
      name_effective = string
      policy = object({
        policy_map = map(object({
          iam_policy_arn = string
        }))
      })
    })
    code_star = object({
      connection = map(object({
        connection_arn = string
        policy_map = map(object({
          iam_policy_arn = string
        }))
      }))
    })
    log = object({
      policy_map = map(object({
        iam_policy_arn = string
      }))
      log_group_name = string
    })
    policy = object({
      vpc_net = object({
        iam_policy_arn = string
      })
    })
    role = object({
      build = object({
        basic = object({
          iam_role_arn = string
        })
      })
    })
  })
}

variable "ci_cd_build_data_map" {
  type = map(object({
    build_map = map(object({
      name_effective = string
    }))
  }))
}

variable "ci_cd_deploy_data_map" {
  type = map(object({
    build_map = map(object({
      name_effective = string
    }))
  }))
  default     = null
  description = "Must be provided if any deployment (app) projects are included"
}

{{ name.var() }}

variable "pipe_map" {
  type = map(object({
    build_data_key = optional(string)
    build_stage_list = list(object({
      action_map = map(object({
        category      = optional(string)
        configuration = optional(map(string)) # If a config is provided all other config vars are ignored
        configuration_build_environment_map = optional(map(object({
          type  = string
          value = string
        })))
        configuration_build_project_key       = optional(string) # Must provide a config or project key
        configuration_deploy_application_name = optional(string) # Must provide all or none for deploy
        configuration_deploy_group_name       = optional(string)
        input_artifact_list                   = optional(list(string))
        # namespace is always StageNameActionKey
        output_artifact      = optional(string) # simply combined with list below
        output_artifact_list = optional(list(string))
        owner                = optional(string)
        provider             = optional(string)
        version              = optional(string)
      }))
      name = string
    }))
    ci_cd_pipeline_webhook_secret_is_param = optional(bool)
    deploy_data_key                        = optional(string) # Defaults to map key
    deploy_stage_list = optional(list(object({
      action_map = map(object({
        category      = optional(string)
        configuration = optional(map(string)) # If a config is provided all other config vars are ignored
        configuration_build_environment_map = optional(map(object({
          type  = string
          value = string
        })))
        configuration_build_project_key       = optional(string) # Must provide a config or project key
        configuration_deploy_application_name = optional(string) # Must provide all or none for deploy
        configuration_deploy_group_name       = optional(string)
        input_artifact_list                   = optional(list(string))
        # namespace is always StageNameActionKey
        output_artifact      = optional(string) # simply combined with list below
        output_artifact_list = optional(list(string))
        owner                = optional(string)
        provider             = optional(string)
        version              = optional(string)
      }))
      name = string
    })), [])
    {{ name.var_item() }}
    # The permissions below are the special sauce for the site build; log write and artifact read/write come free
    {{ iam.role_var_item() }}
    source_artifact_format          = optional(string)
    source_branch                   = optional(string)
    source_code_star_connection_key = optional(string)
    source_detect_changes           = optional(bool)
    source_repository_id            = optional(string)
    webhook_enabled                 = optional(bool)
    webhook_enable_github_hook      = optional(bool)
  }))
}

variable "pipe_build_data_key_default" {
  type        = string
  default     = null
  description = "Defaults to map key"
}

variable "pipe_source_artifact_format_default" {
  type    = string
  default = "CODE_ZIP"
  validation {
    condition     = contains(["CODEBUILD_CLONE_REF", "CODE_ZIP"], var.pipe_source_artifact_format_default)
    error_message = "Invalid artifact format"
  }
}

variable "pipe_source_branch_default" {
  type    = string
  default = "main"
}

variable "pipe_source_code_star_connection_key_default" {
  type    = string
  default = null
}

variable "pipe_source_detect_changes_default" {
  type    = bool
  default = true
}

variable "pipe_source_repository_id_default" {
  type    = string
  default = null
}

variable "pipe_stage_category_default" {
  type    = string
  default = "Build"
}

variable "pipe_webhook_enabled_default" {
  type    = bool
  default = true
}

variable "pipe_webhook_enable_github_hook_default" {
  type        = bool
  default     = false
  description = "Ignored if webhook is not enabled"
}

variable "pipe_webhook_secret_is_param_default" {
  type        = bool
  default     = false
  description = "If true, an SSM param will be created, otherwise a SM secret"
}

{{ std.map() }}
