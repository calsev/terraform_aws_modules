variable "bucket_map" {
  type = map(object({
    allowed_headers                   = optional(list(string))
    allowed_origins                   = optional(list(string))
    allow_public                      = optional(bool)
    create_policy                     = optional(bool)
    enable_acceleration               = optional(bool)
    encryption_algorithm              = optional(string)
    encryption_disabled               = optional(bool)
    lifecycle_expiration_days         = optional(number)
    lifecycle_upload_expiration_days  = optional(number)
    lifecycle_version_count           = optional(number)
    lifecycle_version_expiration_days = optional(number) # Defaults to lifecycle_expiration_days
    name_infix                        = optional(bool)
    notification_enable_event_bridge  = optional(bool)
    requester_pays                    = optional(bool)
    sid_map = optional(map(object({
      access = string
      condition_map = optional(map(object({
        test       = string
        value_list = list(string)
        variable   = string
      })))
      identifier_list = optional(list(string))
      identifier_type = optional(string)
      object_key_list = optional(list(string))
    })))
    versioning_enabled = optional(bool)
    website_domain     = optional(string)
    website_fqdn       = optional(string)
  }))
}

variable "bucket_allowed_headers_default" {
  type    = list(string)
  default = ["*"]
}

variable "bucket_allowed_origins_default" {
  type    = list(string)
  default = ["*"]
}

variable "bucket_allow_public_default" {
  type    = bool
  default = false
}

variable "bucket_create_policy_default" {
  type    = bool
  default = true
}

variable "bucket_enable_acceleration_default" {
  type    = bool
  default = false
}

variable "bucket_encryption_algorithm_default" {
  type        = string
  default     = "AES256"
  description = "The two options are AES256 and aws:kms. KMS entails additional charges."
}

variable "bucket_encryption_disabled_default" {
  type    = bool
  default = false
}

variable "bucket_lifecycle_expiration_days_default" {
  type    = number
  default = null
}

variable "bucket_lifecycle_upload_expiration_days_default" {
  type    = number
  default = 5
}

variable "bucket_lifecycle_version_count_default" {
  type    = number
  default = null
}

variable "bucket_lifecycle_version_expiration_days_default" {
  type    = number
  default = null
}

variable "bucket_name_infix_default" {
  type    = bool
  default = true
}

variable "bucket_notification_enable_event_bridge_default" {
  type    = bool
  default = false
}

variable "bucket_requester_pays_default" {
  type    = bool
  default = false
}

variable "bucket_versioning_enabled_default" {
  type    = bool
  default = false
}

variable "bucket_website_domain_default" {
  type    = string
  default = null
}

variable "dns_data" {
  type = object({
    domain_to_dns_zone_map = map(object({
      dns_zone_id = string
    }))
  })
  default = null
}

variable "std_map" {
  type = object({
    access_title_map               = map(string)
    aws_account_id                 = string
    aws_region_name                = string
    iam_partition                  = string
    resource_name_prefix           = string
    resource_name_suffix           = string
    service_resource_access_action = map(map(map(list(string))))
    tags                           = map(string)
  })
}
