variable "ci_cd_account_data" {
  type = object({
    bucket = object({
      name_effective = string
    })
    code_star = object({
      connection = map(object({
        connection_arn = string
      }))
    })
  })
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

variable "pipe_map" {
  type = map(object({
    iam_role_arn            = optional(string)
    name_append             = optional(string)
    name_include_app_fields = optional(bool)
    name_infix              = optional(bool)
    name_prefix             = optional(string)
    name_prepend            = optional(string)
    name_suffix             = optional(string)
    pipeline_type           = optional(string)
    secret_is_param         = optional(bool)
    # There is always a source stage, that uses namespace "SourceSource" and produces zip artifact "SourceArtifact"
    source_artifact_encryption_key  = optional(string)
    source_artifact_format          = optional(string)
    source_branch                   = optional(string)
    source_code_star_connection_key = optional(string)
    source_detect_changes           = optional(bool)
    source_repository_id            = optional(string) # e.g. user-name/repo-name
    stage_list = list(object({
      action_map = map(object({
        category      = optional(string)
        configuration = optional(map(string)) # If a config is provided all other config vars are ignored
        configuration_build_environment_map = optional(map(object({
          type  = string
          value = string
        })))
        configuration_build_project_name      = optional(string)
        configuration_deploy_application_name = optional(string) # Must provide all or none for deploy
        configuration_deploy_group_name       = optional(string)
        iam_role_arn                          = optional(string)
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
    trigger_pull_request_event_list = optional(list(string))
    variable_map                    = optional(map(string))
    webhook_enabled                 = optional(bool)
    webhook_event_list              = optional(list(string))
    webhook_filter_map = optional(map(object({ # This will be merged over the filter for branch at source_branch
      json_path    = string
      match_equals = string
    })))
  }))
}

variable "pipe_iam_role_arn_default" {
  type    = string
  default = null
}

variable "pipe_pipeline_type_default" {
  type    = string
  default = "V2"
}

variable "pipe_source_artifact_encryption_key_default" {
  type    = string
  default = "alias/aws/s3"
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

variable "pipe_stage_iam_role_arn_default" {
  type    = string
  default = null
}

variable "pipe_stage_input_artifact_list_default" {
  type    = list(string)
  default = ["SourceArtifact"]
}

variable "pipe_stage_owner_default" {
  type    = string
  default = "AWS"
}

variable "pipe_stage_provider_default" {
  type    = string
  default = "CodeBuild"
}

variable "pipe_stage_version_default" {
  type    = string
  default = "1"
}

variable "pipe_trigger_pull_request_event_list_default" {
  type    = list(string)
  default = []
  validation {
    condition     = length(setsubtract(toset(var.pipe_trigger_pull_request_event_list_default), toset(["CLOSED", "OPEN", "UPDATED"]))) == 0
    error_message = "Invalid event list"
  }
}

variable "pipe_variable_map_default" {
  type        = map(string)
  default     = {}
  description = "A mapping of variable name to variable value"
}

variable "pipe_webhook_enabled_default" {
  type    = bool
  default = true
}

variable "pipe_webhook_event_list_default" {
  type        = list(string)
  default     = ["push"]
  description = "See https://docs.github.com/en/webhooks/webhook-events-and-payloads#push"
}

variable "pipe_webhook_filter_map_default" {
  type = map(object({
    json_path    = string
    match_equals = string
  }))
  default     = {}
  description = "This will be merged over the filter for branch at source_branch"
}

variable "pipe_webhook_secret_is_param_default" {
  type        = bool
  default     = false
  description = "If true, an SSM param will be created, otherwise a SM secret"
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
