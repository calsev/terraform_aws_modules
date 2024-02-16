variable "bucket_map" {
  type = map(object({
    allow_public                      = optional(bool)
    cloudfront_origin_access_identity = optional(string)
    cors_allowed_headers              = optional(list(string))
    cors_allowed_methods              = optional(list(string))
    cors_allowed_origins              = optional(list(string))
    cors_expose_headers               = optional(list(string))
    enable_acceleration               = optional(bool)
    encryption_algorithm              = optional(string)
    encryption_disabled               = optional(bool)
    encryption_kms_master_key_id      = optional(string)
    enforce_object_ownership          = optional(bool)
    lifecycle_expiration_days         = optional(number)
    lifecycle_upload_expiration_days  = optional(number)
    lifecycle_version_count           = optional(number)
    lifecycle_version_expiration_days = optional(number) # Defaults to lifecycle_expiration_days
    name_infix                        = optional(bool)
    notification_enable_event_bridge  = optional(bool)
    policy_create                     = optional(bool)
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
    tags               = optional(map(string))
    versioning_enabled = optional(bool)
    website_domain     = optional(string)
    website_enabled    = optional(bool)
    website_fqdn       = optional(string)
  }))
}

variable "bucket_allow_public_default" {
  type        = bool
  default     = false
  description = "There are 2 ways to access an S3 object: S3 URI and S3 website. 3 settings govern public access. allow_public is required for ANY public access."
}

variable "bucket_cors_allowed_headers_default" {
  type    = list(string)
  default = ["*"]
}

variable "bucket_cors_allowed_methods_default" {
  type = list(string)
  default = [
    "GET",
    "HEAD",
  ]
}

variable "bucket_cors_allowed_origins_default" {
  type    = list(string)
  default = ["*"]
}

variable "bucket_cors_expose_headers_default" {
  type    = list(string)
  default = []
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
  type        = bool
  default     = false
  description = "allow_public AND encryption_disabled are required for public S3 URI access. For public access, it is recommended to encrypt objects and use website access; otherwise objects will not be encrypted if public access is removed."
}

variable "bucket_encryption_kms_master_key_id_default" {
  type    = string
  default = null
}

variable "bucket_enforce_object_ownership_default" {
  type    = bool
  default = true
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

variable "bucket_policy_create_default" {
  type    = bool
  default = true
}

variable "bucket_requester_pays_default" {
  type    = bool
  default = false
}

variable "bucket_sid_condition_map_default" {
  type = map(object({
    test       = string
    value_list = list(string)
    variable   = string
  }))
  default = {}
}

variable "bucket_sid_identifier_list_default" {
  type    = list(string)
  default = ["*"]
}

variable "bucket_sid_identifier_type_default" {
  type    = string
  default = "*"
}

variable "bucket_sid_object_key_list_default" {
  type    = list(string)
  default = ["*"]
}

variable "bucket_tags_default" {
  type    = map(string)
  default = {}
}

variable "bucket_versioning_enabled_default" {
  type    = bool
  default = false
}

variable "bucket_website_domain_default" {
  type    = string
  default = null
}

variable "bucket_website_enabled_default" {
  type        = bool
  default     = true
  description = "allow_public AND website_enabled are required for public web access. Otherwise, if website_enabled then the website will be private (use resource policy for CIDR access). Website access automatically decrypts objects."
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
    name_replace_regex             = string
    resource_name_prefix           = string
    resource_name_suffix           = string
    service_resource_access_action = map(map(map(list(string))))
    tags                           = map(string)
  })
}
