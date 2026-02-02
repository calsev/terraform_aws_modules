variable "connection_data_map" {
  type = map(object({
    name_effective = string
  }))
  default     = null
  description = "Must be provided if any job specifies a connection key."
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

variable "job_map" {
  type = map(object({
    argument_default_map            = optional(map(string))
    argument_non_overridable_map    = optional(map(string))
    capacity_max_concurrent_jobs    = optional(number)
    capacity_num_worker_per_job     = optional(number)
    command_name                    = optional(string)
    command_python_version          = optional(string)
    command_runtime                 = optional(string)
    command_script_s3_uri           = optional(string)
    connection_key_list             = optional(list(string))
    execution_class                 = optional(string)
    glue_version                    = optional(string)
    role_policy_attach_arn_map      = optional(map(string))
    role_policy_create_json_map     = optional(map(string))
    role_policy_inline_json_map     = optional(map(string))
    role_policy_managed_name_map    = optional(map(string))
    role_path                       = optional(string)
    job_mode                        = optional(string)
    maintenance_window_utc          = optional(string)
    name_append                     = optional(string)
    name_include_app_fields         = optional(bool)
    name_infix                      = optional(bool)
    name_prefix                     = optional(string)
    name_prepend                    = optional(string)
    name_suffix                     = optional(string)
    notification_run_delay_minutes  = optional(number)
    retries_max                     = optional(number)
    run_queuing_enabled             = optional(bool)
    security_configuration_name     = optional(string)
    source_control_auth_strategy    = optional(string)
    source_control_auth_token       = optional(string)
    source_control_branch           = optional(string)
    source_control_last_commit_id   = optional(string)
    source_control_owner            = optional(string)
    source_control_provider         = optional(string)
    source_control_rel_path_in_repo = optional(string)
    source_control_repository       = optional(string)
    timeout_minutes                 = optional(number)
    worker_type                     = optional(string)
  }))
}

variable "job_argument_default_map_default" {
  type    = map(string)
  default = {}
}

variable "job_argument_non_overridable_map_default" {
  type    = map(string)
  default = {}
}

variable "job_capacity_max_concurrent_jobs_default" {
  type    = number
  default = 1
}

variable "job_capacity_num_worker_per_job_default" {
  type    = number
  default = 1
}

variable "job_command_name_default" {
  type    = string
  default = "glueetl"
  validation {
    condition     = contains(["glueetl", "glueray", "gluestreaming"], var.job_command_name_default)
    error_message = "Invalid command runtime"
  }
}

variable "job_command_python_version_default" {
  type    = string
  default = "3"
}

variable "job_command_runtime_default" {
  type        = string
  default     = null
  description = "For Ray jobs"
}

variable "job_command_script_s3_uri_default" {
  type    = string
  default = null
}

variable "job_connection_key_list_default" {
  type    = list(string)
  default = []
}

variable "job_execution_class_default" {
  type    = string
  default = "STANDARD"
  validation {
    condition     = contains(["FLEX", "STANDARD"], var.job_execution_class_default)
    error_message = "Invalid execution class"
  }
}

variable "job_glue_version_default" {
  type    = string
  default = "5.1"
}

variable "job_mode_default" {
  type    = string
  default = "SCRIPT"
  validation {
    condition     = contains(["NOTEBOOK", "SCRIPT", "VISUAL"], var.job_mode_default)
    error_message = "Invalid job mode"
  }
}

variable "job_maintenance_window_utc_default" {
  type        = string
  default     = "Sun:07"
  description = "Ignored for non-streaming jobs"
}

variable "job_notification_run_delay_minutes_default" {
  type    = number
  default = null
}

variable "job_retries_max_default" {
  type    = number
  default = 0
}

variable "job_run_queuing_enabled_default" {
  type    = bool
  default = false
}

variable "job_security_configuration_name_default" {
  type    = string
  default = null
}

variable "job_source_control_auth_strategy_default" {
  type    = string
  default = null
  validation {
    condition     = var.job_source_control_auth_strategy_default == null ? true : contains(["AWS_SECRETS_MANAGER", "PERSONAL_ACCESS_TOKEN"], var.job_source_control_auth_strategy_default)
    error_message = "Invalid source control auth strategy"
  }
}

variable "job_source_control_auth_token_default" {
  type    = string
  default = null
}

variable "job_source_control_branch_default" {
  type    = string
  default = null
}

variable "job_source_control_last_commit_id_default" {
  type    = string
  default = null
}

variable "job_source_control_owner_default" {
  type    = string
  default = null
}

variable "job_source_control_provider_default" {
  type    = string
  default = null
  validation {
    condition     = var.job_source_control_provider_default == null ? true : contains(["AWS_CODE_COMMIT", "BITBUCKET", "GITHUB", "GITLAB"], var.job_source_control_provider_default)
    error_message = "Invalid source control provider"
  }
}

variable "job_source_control_rel_path_in_repo_default" {
  type    = string
  default = null
}

variable "job_source_control_repository_default" {
  type    = string
  default = null
}

variable "job_timeout_minutes_default" {
  type        = number
  default     = null
  description = "Defaults to 0 for gluestreaming, null for glueray, and 48 hours for glueetl and pythonshell jobs."
}

variable "job_worker_type_default" {
  type    = string
  default = "Standard"
  validation {
    condition     = contains(["G.1X", "G.025X", "G.2X", "G.4X", "G.8X", "G.12X", "G.16X", "R.1X", "R.2X", "R.4X", "R.8X", "Z.2X", "Standard"], var.job_worker_type_default)
    error_message = "Invalid worker type"
  }
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
