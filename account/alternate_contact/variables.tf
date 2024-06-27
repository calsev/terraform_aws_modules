variable "contact_map" {
  # Must go to AWS Organizations > Services > AWS Account Management and enable Trusted access
  # OR run
  # aws organizations enable-aws-service-access --service-principal account.amazonaws.com
  type = map(object({
    account_id             = optional(string)
    alternate_contact_type = optional(string)
    email_address          = optional(string)
    name                   = optional(string)
    phone_number           = optional(string)
    title                  = optional(string)
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

variable "std_map" {
  type = object({
    aws_account_id       = string
    name_replace_regex   = string
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}
