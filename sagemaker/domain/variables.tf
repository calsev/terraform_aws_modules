variable "domain_map" {
  type = map(object({
    app_network_access_type                                         = optional(string)
    app_security_group_management                                   = optional(string)
    auth_mode                                                       = optional(string)
    code_editor_built_in_lifecycle_config_arn                       = optional(string)
    create_kms_key                                                  = optional(bool)
    custom_image_config_name                                        = optional(string)
    custom_image_name                                               = optional(string)
    custom_image_version_number                                     = optional(number)
    domain_execution_role_user_profile_identity_enabled             = optional(bool)
    domain_r_studio_connect_url                                     = optional(string)
    domain_r_studio_package_manager_url                             = optional(string)
    ebs_volume_size_default_gib                                     = optional(number)
    ebs_volume_size_max_gib                                         = optional(number)
    efs_custom_file_system_id                                       = optional(string)
    efs_custom_file_system_path                                     = optional(string)
    emr_assumable_iam_role_arn_list                                 = optional(list(string))
    idle_lifecycle_management_enabled                               = optional(bool)
    idle_timeout_max_minutes                                        = optional(number)
    idle_timeout_min_minutes                                        = optional(number)
    idle_timeout_minutes                                            = optional(number)
    jupyter_lab_built_in_lifecycle_config_arn                       = optional(string)
    jupyter_lab_code_repository_url                                 = optional(string)
    jupyter_lab_lifecycle_config_arn_list                           = optional(list(string))
    jupyter_server_code_repository_url                              = optional(string)
    jupyter_server_lifecycle_config_arn_list                        = optional(list(string))
    kernel_gateway_lifecycle_config_arn_list                        = optional(list(string))
    name_append                                                     = optional(string)
    name_include_app_fields                                         = optional(bool)
    name_infix                                                      = optional(bool)
    name_prefix                                                     = optional(string)
    name_prepend                                                    = optional(string)
    name_suffix                                                     = optional(string)
    posix_custom_gid                                                = optional(number)
    posix_custom_uid                                                = optional(number)
    r_studio_server_pro_access_enabled                              = optional(bool)
    r_studio_server_pro_user_group                                  = optional(string)
    resource_default_instance_type                                  = optional(string)
    resource_default_lifecycle_config_arn                           = optional(string)
    resource_default_sagemaker_image_arn                            = optional(string)
    resource_default_sagemaker_image_version_alias                  = optional(string)
    resource_default_sagemaker_image_version_arn                    = optional(string)
    retention_home_efs_file_system_enabled                          = optional(bool)
    role_policy_attach_arn_map                                      = optional(map(string))
    role_policy_create_json_map                                     = optional(map(string))
    role_policy_inline_json_map                                     = optional(map(string))
    role_policy_managed_name_map                                    = optional(map(string))
    role_path                                                       = optional(string)
    s3_bucket_key                                                   = optional(string)
    studio_web_portal_enabled                                       = optional(bool)
    user_auto_mount_home_efs                                        = optional(string)
    user_canvas_direct_deploy_enabled                               = optional(bool)
    user_canvas_identity_provider_oauth_data_source_name            = optional(string)
    user_canvas_identity_provider_oauth_enabled                     = optional(bool)
    user_canvas_identity_provider_oauth_secret_arn                  = optional(string)
    user_canvas_kendra_enabled                                      = optional(bool)
    user_canvas_model_cross_account_model_registration_enabled      = optional(bool)
    user_canvas_model_cross_account_model_registration_iam_role_arn = optional(string)
    user_canvas_time_series_forecasting_enabled                     = optional(bool)
    user_canvas_time_series_forecasting_iam_role_arn                = optional(string)
    user_code_editor_lifecycle_config_arn_list                      = optional(list(string))
    user_default_landing_uri                                        = optional(string)
    user_domain_docker_access_enabled                               = optional(bool)
    user_domain_vpc_only_trusted_account_list                       = optional(list(string))
    user_emr_serverless_enabled                                     = optional(bool)
    user_sharing_notebook_output_enabled                            = optional(bool)
    user_studio_web_portal_hidden_app_type_list                     = optional(list(string))
    user_studio_web_portal_hidden_instance_type_list                = optional(list(string))
    user_studio_web_portal_hidden_ml_tool_list                      = optional(list(string))
    vpc_az_key_list                                                 = optional(list(string))
    vpc_key                                                         = optional(string)
    vpc_security_group_key_list                                     = optional(list(string))
    vpc_segment_key                                                 = optional(string)
  }))
}

variable "domain_app_network_access_type_default" {
  type    = string
  default = "VpcOnly"
  validation {
    condition     = contains(["PublicInternetOnly", "VpcOnly"], var.domain_app_network_access_type_default)
    error_message = "Invalid app network access type"
  }
}

variable "domain_app_security_group_management_default" {
  type    = string
  default = "Customer"
  validation {
    condition     = contains(["Customer", "Service"], var.domain_app_security_group_management_default)
    error_message = "Invalid app security group management"
  }
}

variable "domain_auth_mode_default" {
  type    = string
  default = "IAM"
  validation {
    condition     = contains(["IAM", "SSO"], var.domain_auth_mode_default)
    error_message = "Invalid auth mode"
  }
}

variable "domain_code_editor_built_in_lifecycle_config_arn_default" {
  type    = string
  default = null
}

variable "domain_create_kms_key_default" {
  type        = bool
  default     = true
  description = "A security finding if disabled"
}

variable "domain_custom_image_config_name_default" {
  type    = string
  default = null
}

variable "domain_custom_image_name_default" {
  type    = string
  default = null
}

variable "domain_custom_image_version_number_default" {
  type    = number
  default = null
}

variable "domain_execution_role_user_profile_identity_enabled_default" {
  type    = bool
  default = true
}

variable "domain_r_studio_connect_url_default" {
  type    = string
  default = null
}

variable "domain_r_studio_package_manager_url_default" {
  type    = string
  default = null
}

variable "domain_ebs_volume_size_default_gib_default" {
  type    = number
  default = 80
}

variable "domain_ebs_volume_size_max_gib_default" {
  type    = number
  default = 1024
}

variable "domain_efs_custom_file_system_id_default" {
  type    = string
  default = null
}

variable "domain_efs_custom_file_system_path_default" {
  type    = string
  default = null
}

variable "domain_emr_assumable_iam_role_arn_list_default" {
  type    = list(string)
  default = []
}

variable "domain_idle_lifecycle_management_enabled_default" {
  type    = bool
  default = true
}

variable "domain_idle_timeout_max_minutes_default" {
  type    = number
  default = 60 * 24 * 7
  validation {
    condition     = 60 <= var.domain_idle_timeout_max_minutes_default && var.domain_idle_timeout_max_minutes_default <= 525600
    error_message = "Invalid idle timeout max minutes"
  }
}

variable "domain_idle_timeout_min_minutes_default" {
  type    = number
  default = 60
  validation {
    condition     = 60 <= var.domain_idle_timeout_min_minutes_default && var.domain_idle_timeout_min_minutes_default <= 525600
    error_message = "Invalid idle timeout min minutes"
  }
}

variable "domain_idle_timeout_minutes_default" {
  type    = number
  default = 120
  validation {
    condition     = 60 <= var.domain_idle_timeout_minutes_default && var.domain_idle_timeout_minutes_default <= 525600
    error_message = "Invalid idle timeout in minutes"
  }
}

variable "domain_jupyter_lab_built_in_lifecycle_config_arn_default" {
  type    = string
  default = null
}

variable "domain_jupyter_lab_code_repository_url_default" {
  type    = string
  default = null
}

variable "domain_jupyter_lab_lifecycle_config_arn_list_default" {
  type    = list(string)
  default = []
}

variable "domain_jupyter_server_code_repository_url_default" {
  type    = string
  default = null
}

variable "domain_jupyter_server_lifecycle_config_arn_list_default" {
  type    = list(string)
  default = []
}

variable "domain_kernel_gateway_lifecycle_config_arn_list_default" {
  type    = list(string)
  default = []
}

variable "domain_posix_custom_gid_default" {
  type    = number
  default = null
}

variable "domain_posix_custom_uid_default" {
  type    = number
  default = null
}

variable "domain_r_studio_server_pro_access_enabled_default" {
  type        = bool
  default     = false
  description = "Requires app_security_group_management = Service"
}

variable "domain_r_studio_server_pro_user_group_default" {
  type    = string
  default = "R_STUDIO_ADMIN"
  validation {
    condition     = contains(["R_STUDIO_ADMIN", "R_STUDIO_USER"], var.domain_r_studio_server_pro_user_group_default)
    error_message = "Invalid r studio server pro user group"
  }
}

variable "domain_resource_default_instance_type_default" {
  type    = string
  default = null
}

variable "domain_resource_default_lifecycle_config_arn_default" {
  type    = string
  default = null
}

variable "domain_resource_default_sagemaker_image_arn_default" {
  type    = string
  default = null
}

variable "domain_resource_default_sagemaker_image_version_alias_default" {
  type    = string
  default = null
}

variable "domain_resource_default_sagemaker_image_version_arn_default" {
  type    = string
  default = null
}

variable "domain_retention_home_efs_file_system_enabled_default" {
  type    = bool
  default = true
}

variable "domain_s3_bucket_key_default" {
  type    = string
  default = null
}

variable "domain_studio_web_portal_enabled_default" {
  type    = bool
  default = true
}

variable "domain_user_auto_mount_home_efs_default" {
  type    = string
  default = "Enabled"
  validation {
    condition     = contains(["Enabled", "DefaultAsDomain", "Disabled"], var.domain_user_auto_mount_home_efs_default)
    error_message = "Invalid user auto mount home efs"
  }
  description = "DefaultAsDomain can only be specified for user profiles"
}

variable "domain_user_canvas_direct_deploy_enabled_default" {
  type    = bool
  default = true
}

variable "domain_user_canvas_identity_provider_oauth_data_source_name_default" {
  type    = string
  default = null
  validation {
    condition     = var.domain_user_canvas_identity_provider_oauth_data_source_name_default == null ? true : contains(["SalesforceGenie", "Snowflake"], var.domain_user_canvas_identity_provider_oauth_data_source_name_default)
    error_message = "Invalid user canvas identity provider oauth data source name"
  }
}

variable "domain_user_canvas_identity_provider_oauth_enabled_default" {
  type    = bool
  default = false
}

variable "domain_user_canvas_identity_provider_oauth_secret_arn_default" {
  type    = string
  default = null
}

variable "domain_user_canvas_kendra_enabled_default" {
  type    = bool
  default = true
}

variable "domain_user_canvas_model_cross_account_model_registration_enabled_default" {
  type    = bool
  default = true
}

variable "domain_user_canvas_model_cross_account_model_registration_iam_role_arn_default" {
  type    = string
  default = null
}

variable "domain_user_canvas_time_series_forecasting_enabled_default" {
  type    = bool
  default = true
}

variable "domain_user_canvas_time_series_forecasting_iam_role_arn_default" {
  type    = string
  default = null
}

variable "domain_user_code_editor_lifecycle_config_arn_list_default" {
  type    = list(string)
  default = []
}

variable "domain_user_default_landing_uri_default" {
  type    = string
  default = null
}

variable "domain_user_domain_docker_access_enabled_default" {
  type    = bool
  default = true
}

variable "domain_user_domain_vpc_only_trusted_account_list_default" {
  type    = list(string)
  default = []
}

variable "domain_user_emr_serverless_enabled_default" {
  type    = bool
  default = true
}

variable "domain_user_sharing_notebook_output_enabled_default" {
  type    = bool
  default = true
}

variable "domain_user_studio_web_portal_hidden_app_type_list_default" {
  type    = list(string)
  default = []
}

variable "domain_user_studio_web_portal_hidden_instance_type_list_default" {
  type    = list(string)
  default = []
}

variable "domain_user_studio_web_portal_hidden_ml_tool_list_default" {
  type    = list(string)
  default = []
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
    name_effective = string
    policy = object({
      policy_map = map(object({
        iam_policy_arn = string
      }))
    })
  }))
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

variable "vpc_az_key_list_default" {
  type    = list(string)
  default = ["a", "b"]
}

variable "vpc_data_map" {
  type = map(object({
    security_group_id_map = map(string)
    segment_map = map(object({
      route_public  = bool
      subnet_id_map = map(string)
    }))
    vpc_id = string
  }))
}

variable "vpc_key_default" {
  type    = string
  default = null
}

variable "vpc_security_group_key_list_default" {
  type = list(string)
  default = [
    "internal_http_in",
    "internal_nfs_in",
    "world_all_out",
  ]
}

variable "vpc_segment_key_default" {
  type    = string
  default = "internal"
}
