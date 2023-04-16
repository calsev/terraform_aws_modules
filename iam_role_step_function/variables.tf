variable "log_data" {
  type = object({
    iam_policy_arn_map = object({
      read  = string
      write = string
    })
  })
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
  type        = map(string)
  default     = {}
  description = "The special sauce for the role; log write and artifact read/write come free"
}

variable "policy_create_json_map" {
  type    = map(string)
  default = {}
}

variable "policy_inline_json_map" {
  type    = map(string)
  default = {}
}

variable "policy_managed_name_map" {
  type        = map(string)
  default     = {}
  description = "The short identifier of the managed policy, the part after 'arn:<iam_partition>:iam::aws:policy/'"
}

variable "role_path" {
  type    = string
  default = null
}

variable "std_map" {
  type = object({
    aws_account_id                 = string
    iam_partition                  = string
    resource_name_prefix           = string
    resource_name_suffix           = string
    service_resource_access_action = map(map(map(list(string))))
    tags                           = map(string)
  })
}
