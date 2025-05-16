variable "account_map" {
  type = map(object({
    close_on_deletion_enabled          = optional(bool)
    create_govcloud                    = optional(bool)
    email_address                      = optional(string)
    iam_user_access_to_billing_allowed = optional(bool)
    iam_user_access_to_billing_null    = optional(bool, false) # For imported accounts - replaced if this changes from null
    name_append                        = optional(string)
    name_include_app_fields            = optional(bool)
    name_infix                         = optional(bool)
    name_prefix                        = optional(string)
    name_prepend                       = optional(string)
    name_suffix                        = optional(string)
    parent_id                          = optional(string)
    role_name                          = optional(string)
  }))
}

variable "account_close_on_deletion_enabled_default" {
  type    = bool
  default = true
}

variable "account_create_govcloud_default" {
  type    = bool
  default = false
}

variable "account_email_address_default" {
  type    = string
  default = null
}

variable "account_iam_user_access_to_billing_allowed_default" {
  type    = bool
  default = true
}

variable "account_parent_id_default" {
  type    = string
  default = null
}

variable "account_role_name_default" {
  type        = string
  default     = "organization-account-access-role"
  description = "AWS defaults this to OrganizationAccountAccessRole"
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
  default     = false
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
