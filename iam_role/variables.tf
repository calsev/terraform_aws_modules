variable "assume_role_json" {
  type    = string
  default = null
}

variable "assume_role_service_list" {
  type    = list(string)
  default = null
}

variable "create_instance_profile" {
  type    = bool
  default = false
}

variable "max_session_duration" {
  type    = number
  default = null
}

variable "name" {
  type = string
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
  default = null
}

variable "policy_managed_name_map" {
  type        = map(string)
  default     = null
  description = "The short identifier of the managed policy, the part after 'arn:<iam_partition>:iam::aws:policy/'"
}

variable "role_path" {
  type    = string
  default = null
}

variable "std_map" {
  type = object({
    iam_partition        = string
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}

variable "tag" {
  type    = bool
  default = true
}
