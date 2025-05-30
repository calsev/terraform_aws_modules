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
    {{ name.var_item() }}
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

{{ name.var() }}

{{ iam.policy_var_ar(append="efs") }}

{{ std.map() }}

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
