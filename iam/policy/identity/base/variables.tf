variable "iam_policy_json" {
  type = string
}

variable "name" {
  type        = string
  default     = null
  description = "If provided, a policy will be created"
}

variable "name_infix" {
  type        = bool
  default     = true
  description = "If true, standard resource prefix and suffix context will be applied to the policy"
}

variable "name_prefix" {
  type        = string
  default     = ""
  description = "Prepended before context prefix"
}

variable "name_suffix" {
  type        = string
  default     = ""
  description = "Appended after context suffix"
}

variable "std_map" {
  type = object({
    name_replace_regex   = string
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}

variable "tag" {
  type    = bool
  default = true
}
