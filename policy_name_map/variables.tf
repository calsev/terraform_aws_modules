variable "name_map" {
  type = map(object({
    policy_create       = optional(bool)
    policy_access_list  = optional(list(string))
    policy_name         = optional(string) # Override all name logic
    policy_name_append  = optional(string)
    policy_name_infix   = optional(bool)
    policy_name_prefix  = optional(string) # Consumed by policy module
    policy_name_prepend = optional(string)
    policy_name_suffix  = optional(string) # Consumed by policy module
  }))
}

variable "policy_access_list_default" {
  type = list(string)
}

variable "policy_create_default" {
  type    = bool
  default = true
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
  default = ""
}

variable "policy_name_append_default" {
  type    = string
  default = ""
}

variable "policy_name_suffix_default" {
  type    = string
  default = ""
}

# tflint-ignore: terraform_unused_declarations
variable "std_map" {
  type = object({
    name_replace_regex = string
  })
}
