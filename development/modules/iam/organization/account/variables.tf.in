variable "account_map" {
  type = map(object({
    close_on_deletion_enabled          = optional(bool)
    create_govcloud                    = optional(bool)
    email_address                      = optional(string)
    iam_user_access_to_billing_allowed = optional(bool)
    iam_user_access_to_billing_null    = optional(bool, false) # For imported accounts - replaced if this changes from null
    {{ name.var_item() }}
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

{{ name.var(infix=False) }}

{{ std.map() }}
