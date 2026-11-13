variable "rule_map" {
  type = map(object({
    after                   = optional(string)
    enabled                 = optional(bool)
    lambda_function_arn     = optional(string)
    lambda_invocation_type  = optional(string)
    name_append             = optional(string)
    name_include_app_fields = optional(bool)
    name_infix              = optional(bool)
    name_override           = optional(string)
    name_prefix             = optional(string)
    name_prepend            = optional(string)
    name_suffix             = optional(string)
    recipient_list          = list(string)
    rule_set_name           = optional(string)
    s3_bucket_name          = optional(string)
    s3_object_key_prefix    = optional(string)
    scan_enabled            = optional(bool)
    stop_after              = optional(bool)
    tls_required            = optional(bool)
  }))
}

variable "rule_after_default" {
  type        = string
  default     = null
  description = "Name of the rule this one runs after; null puts it first in the rule set"
}

variable "rule_enabled_default" {
  type    = bool
  default = true
}

variable "rule_lambda_function_arn_default" {
  type    = string
  default = null
}

variable "rule_lambda_invocation_type_default" {
  type        = string
  default     = "Event"
  description = "Event invokes asynchronously (with Lambda's retries); RequestResponse waits up to 30 seconds and can stop or bounce the message"
  validation {
    condition     = contains(["Event", "RequestResponse"], var.rule_lambda_invocation_type_default)
    error_message = "Invalid invocation type"
  }
}

variable "rule_rule_set_name_default" {
  type    = string
  default = null
}

variable "rule_s3_bucket_name_default" {
  type    = string
  default = null
}

variable "rule_s3_object_key_prefix_default" {
  type        = string
  default     = null
  description = "The message is stored at this prefix + its SES message id"
}

variable "rule_scan_enabled_default" {
  type        = bool
  default     = true
  description = "Spam and virus scanning; the verdicts reach the actions"
}

variable "rule_stop_after_default" {
  type        = bool
  default     = false
  description = "If true, later rules in the rule set are not applied to a matching message"
}

variable "rule_tls_required_default" {
  type        = bool
  default     = true
  description = "If true, mail not delivered over TLS is bounced"
}

variable "name_append_default" {
  type        = string
  default     = ""
  description = "Appended after key"
}

variable "name_include_app_fields_default" {
  type        = bool
  default     = true
  description = "If true, standard project context will be prefixed to the name. Ignored if not name_infix."
}

variable "name_infix_default" {
  type        = bool
  default     = true
  description = "If true, standard project prefix and resource suffix will be added to the name"
}

variable "name_prefix_default" {
  type        = string
  default     = ""
  description = "Prepended before context prefix"
}

variable "name_prepend_default" {
  type        = string
  default     = ""
  description = "Prepended before key"
}

# tflint-ignore: terraform_unused_declarations
variable "name_regex_allow_list" {
  type        = list(string)
  default     = []
  description = "By default, all punctuation is replaced by -"
}

variable "name_suffix_default" {
  type        = string
  default     = ""
  description = "Appended after context suffix"
}

variable "std_map" {
  type = object({
    access_title_map               = map(string)
    aws_account_id                 = string
    aws_region_name                = string
    config_name                    = string
    env                            = string
    iam_partition                  = string
    name_replace_regex             = string
    resource_name_prefix           = string
    resource_name_suffix           = string
    service_resource_access_action = map(map(map(list(string))))
    tags                           = map(string)
  })
}
