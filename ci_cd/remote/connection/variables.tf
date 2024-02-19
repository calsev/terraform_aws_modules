variable "connection_map" {
  type = map(object({
    host_key      = optional(string)
    name_override = optional(string) # This is for imported connections
    provider_type = optional(string)
  }))
  description = "These are created in pending state and authorized by whomever does it. Therefore they are linked to the permissions for a user."
}

variable "connection_host_key_default" {
  type    = string
  default = null
}

variable "connection_provider_type_default" {
  type    = string
  default = "GitHub"
}

variable "host_data_map" {
  type = map(object({
    host_arn = string
  }))
}

variable "policy_create" {
  type    = bool
  default = true
}

variable "policy_name" {
  type        = string
  default     = null
  description = "Defaults to code-connection"
}

variable "policy_name_infix" {
  type    = bool
  default = true
}

variable "policy_name_prefix" {
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
