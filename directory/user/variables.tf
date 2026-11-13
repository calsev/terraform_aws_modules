variable "directory_data_map" {
  type = map(object({
    directory_id = string
    name_simple  = string # The FQDN
  }))
}

variable "user_map" {
  type = map(object({
    directory_key = optional(string)
    email_address = optional(string) # Set at creation only
    given_name    = optional(string) # Set at creation only
    surname       = optional(string) # Set at creation only
    user_name     = optional(string) # The sAMAccountName; defaults to the key
  }))
}

variable "user_directory_key_default" {
  type    = string
  default = null
}

variable "password_secret_name_append_default" {
  type    = string
  default = "password"
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
