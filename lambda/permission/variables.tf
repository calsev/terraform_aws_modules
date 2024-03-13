variable "permission_map" {
  type = map(object({
    action      = optional(string)
    lambda_arn  = optional(string) # If null will be omitted
    name_prefix = optional(string)
    principal   = optional(string)
    qualifier   = optional(string)
    source_arn  = optional(string)
  }))
}

variable "permission_action_default" {
  type    = string
  default = "lambda:InvokeFunction"
}

variable "permission_name_prefix_default" {
  type    = string
  default = null
}

variable "permission_principal_default" {
  type        = string
  default     = null
  description = "Typically the service, e.g. events.amazonaws.com"
}

variable "permission_qualifier_default" {
  type    = string
  default = null
}

variable "permission_source_arn_default" {
  type    = string
  default = null
}

variable "std_map" {
  type = object({
    aws_account_id       = string
    name_replace_regex   = string
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}
