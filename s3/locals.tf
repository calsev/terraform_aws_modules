locals {
  bucket_accelerate_map = {
    for k, v in local.bucket_map : k => v if length(split(".", k)) == 1
  }
  bucket_domain_map = {
    for k, v in local.bucket_map : k => v if v.website_fqdn != null
  }
  bucket_encryption_filter = {
    for k, v in local.bucket_map : k => !v.encryption_disabled && !v.allow_public && v.website_fqdn == null
  }
  bucket_encryption_map = {
    for k, v in local.bucket_map : k => v if local.bucket_encryption_filter[k]
  }
  bucket_map = {
    for k, v in var.bucket_map : k => {
      allowed_headers                   = v.allowed_headers == null ? var.bucket_allowed_headers_default : v.allowed_headers
      allowed_origins                   = v.allowed_origins == null ? var.bucket_allowed_origins_default : v.allowed_origins
      allow_public                      = v.allow_public == null ? var.bucket_allow_public_default : v.allow_public
      bucket_name                       = local.name_map[k].name_infix ? local.name_map[k].resource_name : local.name_map[k].name
      create_policy                     = v.create_policy == null ? var.bucket_create_policy_default : v.create_policy
      enable_acceleration               = v.enable_acceleration == null ? var.bucket_enable_acceleration_default : v.enable_acceleration
      encryption_algorithm              = v.encryption_algorithm == null ? var.bucket_encryption_algorithm_default : v.encryption_algorithm
      encryption_disabled               = v.encryption_disabled == null ? var.bucket_encryption_disabled_default : v.encryption_disabled
      lifecycle_expiration_days         = v.lifecycle_expiration_days == null ? var.bucket_lifecycle_expiration_days_default : v.lifecycle_expiration_days
      lifecycle_upload_expiration_days  = v.lifecycle_upload_expiration_days == null ? var.bucket_lifecycle_upload_expiration_days_default : v.lifecycle_upload_expiration_days
      lifecycle_version_count           = v.lifecycle_version_count == null ? var.bucket_lifecycle_version_count_default : v.lifecycle_version_count
      lifecycle_version_expiration_days = v.lifecycle_version_expiration_days == null ? var.bucket_lifecycle_version_expiration_days_default : v.lifecycle_version_expiration_days
      requester_pays                    = v.requester_pays == null ? var.bucket_requester_pays_default : v.requester_pays
      resource_name                     = local.name_map[k].resource_name
      sid_map = v.sid_map == null ? {} : {
        for k, v in v.sid_map : k => {
          access          = v.access
          condition_map   = v.condition_map == null ? {} : v.condition_map
          identifier_list = v.identifier_list == null ? ["*"] : v.identifier_list
          identifier_type = v.identifier_type == null ? "*" : v.identifier_type
          object_key_list = v.object_key_list == null ? ["*"] : v.object_key_list
        }
      }
      tags = merge(
        var.std_map.tags,
        {
          Name = local.name_map[k].resource_name
        }
      )
      versioning_enabled = v.versioning_enabled == null ? var.bucket_versioning_enabled_default : v.versioning_enabled
      website_domain     = v.website_domain == null ? var.bucket_website_domain_default : v.website_domain
      website_fqdn       = v.website_fqdn
    }
  }
  bucket_object = {
    for k, v in local.bucket_map : k => merge(
      {
        for k_bucket, v_bucket in v : k_bucket => v_bucket if !contains(["create_policy", "encryption_algorithm", "encryption_disabled", "resource_name", "sid_map", "tags"], k_bucket)
      },
      {
        arn                     = aws_s3_bucket.this_bucket[k].arn
        bucket_domain_name      = aws_s3_bucket.this_bucket[k].bucket_regional_domain_name
        bucket_policy_doc       = v.create_policy ? jsondecode(module.this_bucket_policy[k].iam_policy_json) : null
        bucket_website_endpoint = aws_s3_bucket.this_bucket[k].website_endpoint
        encryption_algorithm    = local.bucket_encryption_filter[k] ? v.encryption_algorithm : null
      },
    )
  }
  bucket_policy_map = {
    for k, v in local.bucket_map : k => v if v.create_policy
  }
  bucket_web_map = {
    for k, v in local.bucket_map : k => v if v.allow_public || v.website_fqdn != null
  }
  name_map = {
    for k, v in var.bucket_map : k => {
      name          = replace(k, "_", "-") # Do not replace "." in domain names
      name_infix    = v.name_infix == null ? var.bucket_name_infix_default : v.name_infix
      resource_name = "${var.std_map.resource_name_prefix}${replace(k, "/[_.]/", "-")}${var.std_map.resource_name_suffix}"
    }
  }
  region_name_to_s3_dns_zone = {
    # See https://docs.aws.amazon.com/general/latest/gr/s3.html#s3_website_region_endpoints
    us-east-1    = "Z3AQBSTGFYJSTF"
    us-west-2    = "Z3BJ6K6RIION7M"
    eu-central-1 = "Z21DNDUVLTQW6Q"
    eu-south-1   = "Z30OZKI7KPW7MI"
  }
}
