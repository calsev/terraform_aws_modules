variable "bucket_map" {
  type = map(object({
    allow_access_point                 = optional(bool)
    allow_config_recording             = optional(bool)
    allow_insecure_access              = optional(bool)
    allow_log_cloudtrail               = optional(bool)
    allow_log_elb                      = optional(bool)
    allow_log_waf                      = optional(bool)
    allow_public                       = optional(bool)
    cloudfront_origin_access_identity  = optional(string)
    cors_allowed_headers               = optional(list(string))
    cors_allowed_methods               = optional(list(string))
    cors_allowed_origins               = optional(list(string))
    cors_expose_headers                = optional(list(string))
    dns_enabled                        = optional(string)
    dns_from_zone_key                  = optional(string)
    enable_acceleration                = optional(bool)
    encryption_algorithm               = optional(string)
    encryption_disabled                = optional(bool)
    encryption_kms_master_key_id       = optional(string)
    enforce_object_ownership           = optional(bool)
    lifecycle_expiration_days          = optional(number)
    lifecycle_expiration_delete_marker = optional(bool)
    lifecycle_upload_expiration_days   = optional(number)
    lifecycle_transition_map = optional(map(object({
      date          = optional(string)
      days          = optional(number)
      storage_class = optional(string)
    })))
    lifecycle_version_count           = optional(number)
    lifecycle_version_expiration_days = optional(number)
    log_target_bucket_name            = optional(string)
    log_target_prefix                 = optional(string)
    name_append                       = optional(string)
    name_include_app_fields           = optional(bool)
    name_infix                        = optional(bool)
    name_override                     = optional(string)
    name_prefix                       = optional(string)
    name_prepend                      = optional(string)
    name_suffix                       = optional(string)
    notification_enable_event_bridge  = optional(bool)
    notification_lambda_map = optional(map(object({
      event_list          = optional(list(string))
      filter_prefix       = optional(string)
      filter_suffix       = optional(string)
      lambda_function_arn = optional(string)
    })), {})
    policy_access_list     = optional(list(string))
    policy_name_append     = optional(string)
    policy_identity_create = optional(bool)
    policy_resource_create = optional(bool)
    requester_pays         = optional(bool)
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
    tags                          = optional(map(string))
    versioning_enabled            = optional(bool)
    versioning_mfa_delete_enabled = optional(bool)
    website_enabled               = optional(bool)
    website_error_document        = optional(string)
    website_index_document        = optional(string)
  }))
}

variable "bucket_allow_access_point_default" {
  type    = bool
  default = true
}

variable "bucket_allow_config_recording_default" {
  type    = bool
  default = false
}

variable "bucket_allow_insecure_access_default" {
  type    = bool
  default = false
}

variable "bucket_allow_log_cloudtrail_default" {
  type    = bool
  default = false
}

variable "bucket_allow_log_elb_default" {
  type    = bool
  default = false
}

variable "bucket_allow_log_waf_default" {
  type    = bool
  default = false
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
  type        = list(string)
  default     = []
  description = "Will have the bucket FQDN prepended if dns_enabled and bucket website_endpoint if website_enabled"
}

variable "bucket_cors_expose_headers_default" {
  type    = list(string)
  default = []
}

variable "bucket_dns_enabled_default" {
  type    = bool
  default = false
}

variable "bucket_dns_from_zone_key_default" {
  type    = string
  default = null
}

variable "bucket_enable_acceleration_default" {
  type    = bool
  default = false
}

variable "bucket_encryption_algorithm_default" {
  type        = string
  default     = null
  description = "Defaults to aws:kms is a kms key is specified, AES256 otherwise. KMS entails additional charges."
  validation {
    condition     = var.bucket_encryption_algorithm_default == null ? true : contains(["AES256", "aws:kms"], var.bucket_encryption_algorithm_default)
    error_message = "Invalid storage class"
  }
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

variable "bucket_lifecycle_expiration_delete_marker_default" {
  type        = bool
  default     = true
  description = "Ignored if lifecycle_expiration_days is specified"
}

variable "bucket_lifecycle_upload_expiration_days_default" {
  type    = number
  default = 5
}

variable "bucket_lifecycle_transition_map_default" {
  type = map(object({
    date          = optional(string)
    days          = optional(number)
    storage_class = optional(string)
  }))
  default = {
    default = {
      date          = null
      days          = null
      storage_class = null
    }
  }
  description = "Each entry ignored if lifecycle_expiration_days is <= days"
}

variable "bucket_lifecycle_transition_date_default" {
  type        = string
  default     = null
  description = "If neither date nor days is specified the default is 0 days. See https://datatracker.ietf.org/doc/html/rfc3339#section-5.6 for valid date format."
}

variable "bucket_lifecycle_transition_days_default" {
  type        = number
  default     = 0
  description = "If neither date nor days is specified the default is 0 days."
}

variable "bucket_lifecycle_transition_storage_class_default" {
  type    = string
  default = "INTELLIGENT_TIERING"
  validation {
    condition     = contains(["DEEP_ARCHIVE", "GLACIER", "GLACIER_IR", "INTELLIGENT_TIERING", "ONEZONE_IA", "STANDARD_IA"], var.bucket_lifecycle_transition_storage_class_default)
    error_message = "Invalid storage class"
  }
}

variable "bucket_lifecycle_version_count_default" {
  type        = number
  default     = 0
  description = "Both version count and days must be satisfied to expire an object"
}

variable "bucket_lifecycle_version_expiration_days_default" {
  type        = number
  default     = 183
  description = "Both version count and days must be satisfied to expire an object"
}

variable "bucket_log_target_bucket_name_default" {
  type        = string
  default     = null
  description = "Set non-null to enable server access logging"
}

variable "bucket_log_target_prefix_default" {
  type    = string
  default = "s3-server-access/"
}

variable "bucket_notification_enable_event_bridge_default" {
  type    = bool
  default = false
}

variable "bucket_notification_lambda_event_list_default" {
  type = list(string)
  default = [
    "s3:ObjectCreated:*",
  ]
}

variable "bucket_notification_lambda_filter_prefix_default" {
  type    = string
  default = null
}

variable "bucket_notification_lambda_filter_suffix_default" {
  type    = string
  default = null
}

variable "bucket_notification_lambda_function_arn_default" {
  type    = string
  default = null
}

variable "bucket_policy_identity_create_default" {
  type    = bool
  default = true
}

variable "bucket_policy_resource_create_default" {
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

variable "bucket_versioning_enabled_default" {
  type        = bool
  default     = true
  description = "A medium-level security finding if disabled. Prevents accidental and forced deletion of the bucket while enabled."
}

variable "bucket_versioning_mfa_delete_enabled_default" {
  type        = bool
  default     = false
  description = "Ignored unless versioning_enabled. Versioning satisfies typical security controls without this. Cannot actually be set true with Terraform, see https://docs.aws.amazon.com/AmazonS3/latest/userguide/MultiFactorAuthenticationDelete.html."
}

variable "bucket_website_enabled_default" {
  type        = bool
  default     = true
  description = "allow_public AND website_enabled are required for public web access. Otherwise, if website_enabled then the website will be private (use resource policy for CIDR access). Website access automatically decrypts objects."
}

variable "bucket_website_error_document_default" {
  type    = string
  default = "error.html"
}

variable "bucket_website_index_document_default" {
  type    = string
  default = "index.html"
}

variable "dns_data" {
  type = object({
    domain_to_dns_zone_map = map(object({
      dns_zone_id = string
    }))
  })
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

variable "policy_access_list_default" {
  type = list(string)
  default = [
    "read",
    "read_write",
    "write",
  ]
}

variable "policy_create_default" {
  type    = bool
  default = true
}

variable "policy_name_append_default" {
  type    = string
  default = "bucket"
}

variable "policy_name_prefix_default" {
  type    = string
  default = ""
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
