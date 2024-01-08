variable "ci_cd_account_data" {
  type = object({
    bucket = object({
      iam_policy_arn_map = map(string)
    })
    log = object({
      iam_policy_arn_map = map(string)
    })
    log_public = optional(object({ # Must be provided if log public access is enabled
      iam_policy_arn_map = map(string)
    }))
    policy = object({
      vpc_net = object({
        iam_policy_arn = string
      })
    })
  })
}

#variable "code_pipe_role_key" {
#  type    = string
#  default = "*code-pipe*"
#}

variable "max_session_duration_m" {
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

variable "log_public_access" {
  type        = bool
  default     = false
  description = "If true, this role will add permissions for the public log"
}

variable "log_bucket_name" {
  type        = string
  default     = null
  description = "If provided, write permissions for the bucket will be added"
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
    access_title_map               = map(string)
    aws_account_id                 = string
    iam_partition                  = string
    name_replace_regex             = string
    resource_name_prefix           = string
    resource_name_suffix           = string
    service_resource_access_action = map(map(map(list(string))))
    tags                           = map(string)
  })
}

variable "tag" {
  type    = bool
  default = true
}

variable "vpc_access" {
  type        = bool
  default     = false
  description = "If true, this role will add permissions for VPC networking"
}
