variable "ci_cd_account_data" {
  type = object({
    bucket = object({
      name_effective = string
    })
    code_star = object({
      connection = map(object({
        arn = string
      }))
    })
  })
}

variable "pipe_map" {
  type = map(object({
    iam_role_arn = optional(string)
    name_infix   = optional(bool)
    # There is always a source stage, that uses namespace "SourceSource" and produces zip artifact "SourceArtifact"
    source_branch          = optional(string)
    source_connection_name = optional(string)
    source_detect_changes  = optional(bool)
    source_repository_id   = optional(string) # e.g. user-name/repo-name
    stage_list = list(object({
      action_map = map(object({
        category      = optional(string)
        configuration = optional(map(string)) # If a config is provided all other config vars are ignored
        configuration_environment_map = optional(map(object({
          type  = string
          value = string
        })))
        configuration_project_name = optional(string) # Must provide a config or project name
        iam_role_arn               = optional(string)
        input_artifact_list        = optional(list(string))
        # namespace is always StageNameActionKey
        output_artifact      = optional(string) # simply combined with list below
        output_artifact_list = optional(list(string))
        owner                = optional(string)
        provider             = optional(string)
        version              = optional(string)
      }))
      name = string
    }))
  }))
}

variable "pipe_iam_role_arn_default" {
  type    = string
  default = null
}

variable "pipe_name_infix_default" {
  type    = bool
  default = true
}

variable "pipe_source_branch_default" {
  type    = string
  default = "main"
}

variable "pipe_source_connection_name_default" {
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

variable "std_map" {
  type = object({
    aws_region_name      = string
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}
