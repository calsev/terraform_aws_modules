variable "contact_map" {
  # Must go to AWS Organizations > Services > AWS Account Management and enable Trusted access
  # OR run
  # aws organizations enable-aws-service-access --service-principal account.amazonaws.com
  type = map(object({
    account_id              = optional(string)
    alternate_contact_type  = optional(string)
    contact_name            = optional(string)
    email_address           = optional(string)
    name_append             = optional(string)
    name_include_app_fields = optional(bool)
    name_infix              = optional(bool)
    name_prefix             = optional(string)
    name_prepend            = optional(string)
    name_suffix             = optional(string)
    phone_number            = optional(string)
    title                   = optional(string)
  }))
}

variable "contact_account_id_default" {
  type        = string
  default     = null
  description = "Defaults to this account from std_map"
}

variable "contact_alternate_contact_type_default" {
  type        = string
  default     = null
  description = "Defaults to key"
  validation {
    condition     = var.contact_alternate_contact_type_default == null ? true : contains(["BILLING", "OPERATIONS", "SECURITY"], var.contact_alternate_contact_type_default)
    error_message = "Invalid alternate contact type"
  }
}

variable "contact_email_address_default" {
  type    = string
  default = null
}

variable "contact_name_default" {
  type    = string
  default = null
}

variable "contact_phone_number_default" {
  type    = string
  default = null
}

variable "contact_title_default" {
  type    = string
  default = null
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
