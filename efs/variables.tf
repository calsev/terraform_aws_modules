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
    policy_access_list          = optional(list(string))
    policy_create               = optional(bool)
    policy_name                 = optional(string)
    policy_name_append          = optional(string)
    policy_name_infix           = optional(bool)
    policy_name_prefix          = optional(string)
    policy_name_prepend         = optional(string)
    policy_name_suffix          = optional(string)
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

variable "policy_access_list_default" {
  type    = list(string)
  default = ["write"]
}

variable "policy_create_default" {
  type    = bool
  default = true
}

variable "policy_name_append_default" {
  type    = string
  default = ""
}

variable "policy_name_infix_default" {
  type    = bool
  default = true
}

variable "policy_name_prefix_default" {
  type    = string
  default = ""
}

variable "policy_name_prepend_default" {
  type    = string
  default = "efs"
}

variable "policy_name_suffix_default" {
  type    = string
  default = ""
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
