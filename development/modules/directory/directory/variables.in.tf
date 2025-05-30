variable "directory_map" {
  type = map(object({
    active_directory_connect_customer_dns_ip_list = optional(list(string))
    active_directory_connect_customer_username    = optional(string)
    active_directory_edition                      = optional(string)
    alias                                         = optional(string)
    directory_type                                = optional(string)
    domain_controller_count                       = optional(number)
    instance_size                                 = optional(string)
    {{ name.var_item() }}
    password_secret_is_param                      = optional(bool)
    password_secret_name_append                   = optional(string)
    short_name                                    = optional(string)
    sso_enabled                                   = optional(bool)
    vpc_az_key_list                               = optional(list(string))
    vpc_key                                       = optional(string)
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

 # Name is a FQDN key
{{ name.var(app_fields=False, allow=["."]) }}

variable "password_secret_name_append_default" {
  type    = string
  default = "password"
}

{{ std.map() }}

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
  type        = string
  default     = "internal"
  description = "Public access requires a security group with open access to 3389 - causing multiple critical- and high-level security findings"
}
