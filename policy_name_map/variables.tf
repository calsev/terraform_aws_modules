variable "name_map" {
  type = map(object({
    create_policy      = optional(bool)
    policy_access_list = optional(list(string))
    policy_name        = optional(string)
    policy_name_infix  = optional(bool)
    policy_name_prefix = optional(string)
  }))
}

variable "create_policy_default" {
  type = bool
}

variable "policy_access_list_default" {
  type = list(string)
}

variable "policy_name_infix_default" {
  type    = bool
  default = true
}

variable "policy_name_prefix_default" {
  type    = string
  default = ""
}

variable "policy_name_suffix" {
  type = string
}

variable "std_map" {
  type = object({
    name_replace_regex = string
  })
}
