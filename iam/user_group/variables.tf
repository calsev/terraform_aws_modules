variable "group_map" {
  type = map(object({
    k_user_list             = optional(list(string))
    name_infix              = optional(string)
    path                    = optional(string)
    policy_attach_arn_map   = optional(map(string), {})
    policy_create_json_map  = optional(map(string), {})
    policy_inline_json_map  = optional(map(string), {})
    policy_managed_name_map = optional(map(string), {})
  }))
  default = {}
}

variable "group_k_user_list_default" {
  type    = list(string)
  default = []
}

variable "group_name_infix_default" {
  type    = bool
  default = true
}

variable "group_path_default" {
  type    = string
  default = "/"
}

variable "std_map" {
  type = object({
    iam_partition        = string
    name_replace_regex   = string
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}

variable "user_map" {
  type = map(object({
    create_access_key       = optional(bool)
    enable_console_access   = optional(bool)
    force_destroy           = optional(bool)
    name_infix              = optional(string)
    path                    = optional(string)
    pgp_key                 = optional(string)
    policy_attach_arn_map   = optional(map(string), {})
    policy_create_json_map  = optional(map(string), {})
    policy_inline_json_map  = optional(map(string), {})
    policy_managed_name_map = optional(map(string), {})
  }))
}

variable "user_create_access_key_default" {
  type    = bool
  default = false
}

variable "user_enable_console_access_default" {
  type    = bool
  default = false
}

variable "user_force_destroy_default" {
  type    = bool
  default = true
}

variable "user_name_infix_default" {
  type    = bool
  default = true
}

variable "user_path_default" {
  type    = string
  default = "/"
}

variable "user_pgp_key_default" {
  type        = string
  default     = null
  description = "A base-64 encoded PGP public key"
}
