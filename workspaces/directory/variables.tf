variable "directory_map" {
  type = map(object({
    ip_group_id_list                                    = optional(list(string))
    name_append                                         = optional(string)
    name_include_app_fields                             = optional(bool)
    name_infix                                          = optional(bool)
    name_prefix                                         = optional(string)
    name_prepend                                        = optional(string)
    name_suffix                                         = optional(string)
    self_service_change_compute_type_allowed            = optional(bool)
    self_service_increase_volume_size_allowed           = optional(bool)
    self_service_rebuild_workspace_allowed              = optional(bool)
    self_service_restart_workspace_allowed_allowed      = optional(bool)
    self_service_switch_running_mode_allowed            = optional(bool)
    service_directory_key                               = optional(string)
    vpc_az_key_list                                     = optional(list(string))
    vpc_key                                             = optional(string)
    vpc_segment_key                                     = optional(string)
    workspace_access_from_android_allowed               = optional(bool)
    workspace_access_from_chrome_os_allowed             = optional(bool)
    workspace_access_from_ios_allowed                   = optional(bool)
    workspace_access_from_linux_allowed                 = optional(bool)
    workspace_access_from_osx_allowed                   = optional(bool)
    workspace_access_from_web_allowed                   = optional(bool)
    workspace_access_from_windows_allowed               = optional(bool)
    workspace_access_from_zero_client_allowed           = optional(bool)
    workspace_creation_internet_access_enabled          = optional(bool)
    workspace_creation_maintenance_mode_enabled         = optional(bool)
    workspace_creation_ou                               = optional(string) # defaults to OU=key,directory_workspace_creation_ou_root_default
    workspace_creation_user_local_administrator_enabled = optional(bool)
    workspace_creation_vpc_security_group_id_custom     = optional(string)
  }))
}

variable "directory_ip_group_id_list_default" {
  type    = list(string)
  default = []
}

variable "directory_self_service_change_compute_type_allowed_default" {
  type    = bool
  default = true
}

variable "directory_self_service_increase_volume_size_allowed_default" {
  type    = bool
  default = true
}

variable "directory_self_service_rebuild_workspace_allowed_default" {
  type    = bool
  default = true
}

variable "directory_self_service_restart_workspace_allowed_allowed_default" {
  type    = bool
  default = true
}

variable "directory_self_service_switch_running_mode_allowed_default" {
  type    = bool
  default = false
}

variable "directory_service_directory_key_default" {
  type    = string
  default = null
}

variable "directory_workspace_access_from_android_allowed_default" {
  type    = bool
  default = true
}

variable "directory_workspace_access_from_chrome_os_allowed_default" {
  type    = bool
  default = true
}

variable "directory_workspace_access_from_ios_allowed_default" {
  type    = bool
  default = true
}

variable "directory_workspace_access_from_linux_allowed_default" {
  type    = bool
  default = true
}

variable "directory_workspace_access_from_osx_allowed_default" {
  type    = bool
  default = true
}

variable "directory_workspace_access_from_web_allowed_default" {
  type    = bool
  default = true
}

variable "directory_workspace_access_from_windows_allowed_default" {
  type    = bool
  default = true
}

variable "directory_workspace_access_from_zero_client_allowed_default" {
  type    = bool
  default = true
}

variable "directory_workspace_creation_internet_access_enabled_default" {
  type    = bool
  default = true
}

variable "directory_workspace_creation_maintenance_mode_enabled_default" {
  type    = bool
  default = true
}

variable "directory_workspace_creation_ou_root_default" {
  type    = string
  default = null
  validation {
    condition     = var.directory_workspace_creation_ou_root_default == null ? true : startswith(var.directory_workspace_creation_ou_root_default, "DC=")
    error_message = "Invalid DC"
  }
}

variable "directory_workspace_creation_user_local_administrator_enabled_default" {
  type    = bool
  default = false
}

variable "directory_workspace_creation_vpc_security_group_id_custom_default" {
  type    = string
  default = null
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

variable "service_directory_data_map" {
  type = map(object({
    directory_id = string
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
    vpc_cidr_block      = string
    vpc_id              = string
    vpc_ipv6_cidr_block = string
  }))
}

variable "vpc_key_default" {
  type    = string
  default = null
}

variable "vpc_segment_key_default" {
  type    = string
  default = "internal"
}
