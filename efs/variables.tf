variable "fs_map" {
  type = map(object({
    access_point_map = optional(map(object({
      owner_gid               = optional(number)
      owner_uid               = optional(number)
      path                    = optional(string)
      permission_mode         = optional(string)
      user_gid                = optional(number)
      user_gid_secondary_list = optional(list(number))
      user_uid                = optional(number)
    })))
    encrypt_file_system         = optional(bool)
    name_append                 = optional(string)
    name_include_app_fields     = optional(bool)
    name_infix                  = optional(bool)
    name_prefix                 = optional(string)
    name_prepend                = optional(string)
    name_suffix                 = optional(string)
    policy_access_list          = optional(list(string))
    policy_create               = optional(bool)
    policy_name_append          = optional(string)
    vpc_az_key_list             = optional(list(string))
    vpc_key                     = optional(string)
    vpc_security_group_key_list = optional(list(string))
    vpc_segment_key             = optional(string)
  }))
}

variable "fs_access_point_map_default" {
  type = map(object({
    owner_gid               = optional(number)
    owner_uid               = optional(number)
    path                    = optional(string) # Defaults to key
    permission_mode         = optional(string)
    user_gid                = optional(number)
    user_gid_secondary_list = optional(list(number))
    user_uid                = optional(number)
  }))
  default = {}
}

variable "fs_access_point_owner_gid_default" {
  type    = number
  default = 0
}

variable "fs_access_point_owner_uid_default" {
  type    = number
  default = 0
}

variable "fs_access_point_permission_mode_default" {
  type    = number
  default = 0755
}

variable "fs_access_point_user_gid_default" {
  type    = number
  default = 0
}

variable "fs_access_point_user_gid_secondary_list_default" {
  type    = list(number)
  default = []
}

variable "fs_access_point_user_uid_default" {
  type    = number
  default = 0
}

variable "fs_encrypt_file_system_default" {
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

variable "policy_access_list_default" {
  type = list(string)
  default = [
    "read",
    "read_write",
    "write",
  ]
}

variable "policy_create_default" {
  type    = bool
  default = true
}

variable "policy_name_append_default" {
  type    = string
  default = "efs"
}

variable "policy_name_prefix_default" {
  type    = string
  default = ""
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
    "internal_nfs_in",
    "world_all_out",
  ]
}

variable "vpc_segment_key_default" {
  type    = string
  default = "internal"
}
