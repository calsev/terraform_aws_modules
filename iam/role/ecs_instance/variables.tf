variable "max_session_duration_m" {
  type    = number
  default = null
}

variable "name_infix" {
  type        = bool
  default     = true
  description = "If true, standard resource prefix and suffix will be applied to the role"
}

variable "name_prefix" {
  type        = string
  default     = ""
  description = "If provided, will be put in front of the standard prefix for the role name."
}

variable "policy_attach_arn_map" {
  type    = map(string)
  default = {}
}

variable "policy_create_json_map" {
  type    = map(string)
  default = {}
}

variable "policy_inline_json_map" {
  type    = map(string)
  default = {}
}

variable "role_path" {
  type    = string
  default = null
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

variable "tag" {
  type    = bool
  default = true
}