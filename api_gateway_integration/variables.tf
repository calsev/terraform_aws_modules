variable "api_map" {
  type = map(object({
    api_id                           = string
    integration_iam_role_arn_default = optional(string)
    integration_map = map(object({
      http_method     = optional(string) # Ignored for sqs, step function
      iam_role_arn    = optional(string)
      subtype         = optional(string)
      target_arn      = optional(string) # Used for step function
      target_uri      = optional(string) # This is ignored for step function
      timeout_seconds = optional(number)
      vpc_link_id     = optional(string)
    }))
  }))
}

variable "integration_http_method_default" {
  type        = string
  default     = "ANY"
  description = "Ignored for integrations with subtype, e.g. SQS, StepFunctions"
}

variable "integration_iam_role_arn_default" {
  type    = string
  default = null
}

variable "integration_subtype_default" {
  type        = string
  default     = null
  description = "Ignored for step function"
  validation {
    condition     = var.integration_subtype_default == null ? true : contains(["step_function"], var.integration_subtype_default)
    error_message = "Invalid integration subtype"
  }
}
variable "integration_target_uri_default" {
  type    = string
  default = null
}

variable "integration_timeout_seconds_default" {
  type    = number
  default = null
}

variable "integration_vpc_link_id_default" {
  type    = string
  default = null
}

variable "std_map" {
  type = object({
    aws_region_name      = string
    iam_partition        = string
    name_replace_regex   = string
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}
