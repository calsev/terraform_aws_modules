variable "directory_map" {
  type = map(object({
    active_directory_connect_customer_dns_ip_list = optional(list(string))
    active_directory_connect_customer_username    = optional(string)
    active_directory_edition                      = optional(string)
    alias                                         = optional(string)
    directory_type                                = optional(string)
    domain_controller_count                       = optional(number)
    instance_size                                 = optional(string)
    name_include_app_fields                       = optional(bool)
    name_infix                                    = optional(bool)
    password_secret_is_param                      = optional(bool)
    short_name                                    = optional(string)
    sso_enabled                                   = optional(bool)
    vpc_az_key_list                               = optional(list(string))
    vpc_key                                       = optional(string)
    vpc_security_group_key_list                   = optional(list(string))
    vpc_segment_key                               = optional(string)
  }))
}

variable "directory_active_directory_connect_customer_dns_ip_list_default" {
  type        = list(string)
  default     = []
  description = "Ingored unless directory_type is ADConnector"
}

variable "directory_active_directory_connect_customer_username_default" {
  type        = string
  default     = null
  description = "Ingored unless directory_type is ADConnector"
}

variable "directory_active_directory_edition_default" {
  type        = string
  default     = null
  description = "Ingored unless directory_type is MicrosoftAD"
}

variable "directory_alias_default" {
  type        = string
  default     = null
  description = "Must be unique in AWS"
}

variable "directory_type_default" {
  type    = string
  default = "SimpleAD"
  validation {
    condition     = contains(["ADConnector", "MicrosoftAD", "SimpleAD"], var.directory_type_default)
    error_message = "Invalid directory type"
  }
}

variable "directory_domain_controller_count_default" {
  type        = number
  default     = null
  description = "Ignored unless directory_type is MicrosoftAD"
  validation {
    condition     = var.directory_domain_controller_count_default == null ? true : var.directory_domain_controller_count_default > 0
    error_message = "Invalid domain controller count"
  }
}

variable "directory_instance_size_default" {
  type    = string
  default = "Small"
  validation {
    condition     = contains(["Large", "Small"], var.directory_instance_size_default)
    error_message = "Invalid instance size"
  }
}

variable "directory_password_secret_is_param_default" {
  type    = bool
  default = false
}

variable "directory_sso_enabled_default" {
  type        = bool
  default     = null
  description = "Defaults to true if alias is non-null"
}

variable "name_include_app_fields_default" {
  type        = bool
  default     = false
  description = "If true, the Terraform project context will be included in the name"
}

variable "name_infix_default" {
  type    = bool
  default = true
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

variable "vpc_az_key_list_default" {
  type    = list(string)
  default = ["a", "b"]
}

variable "vpc_data_map" {
  type = map(object({
    security_group_id_map = map(string)
    segment_map = map(object({
      route_public  = bool
      subnet_id_map = map(string)
    }))
    vpc_id = string
  }))
}

variable "vpc_key_default" {
  type    = string
  default = null
}

variable "vpc_segment_key_default" {
  type    = string
  default = "public"
}
