module "name_map" {
  source                = "../name_map"
  name_infix_default    = var.bucket_name_infix_default
  name_map              = var.bucket_map
  name_regex_allow_list = ["."] # Do not replace "." in domain names
  std_map               = var.std_map
  tags_default          = var.bucket_tags_default
}

locals {
  bucket_accelerate_map = {
    for k, v in local.bucket_map : k => v if v.acceleration_enabled
  }
  bucket_domain_map = {
    for k, v in local.bucket_map : k => v if v.domain_name_enabled
  }
  bucket_map = {
    for k, v in var.bucket_map : k => merge(local.l1_map[k], local.l2_map[k], local.l3_map[k])
  }
  bucket_policy_map = {
    for k, v in local.bucket_map : k => v if v.create_policy
  }
  bucket_web_map = {
    for k, v in local.bucket_map : k => v if v.website_enabled
  }
  l1_map = {
    for k, v in var.bucket_map : k => merge(v, module.name_map.data[k], {
      acceleration_enabled                 = length(split(".", k)) == 1 # TODO: Why not dot buckets?
      allow_public                         = v.allow_public == null ? var.bucket_allow_public_default : v.allow_public
      cloudfront_origin_access_identity    = v.cloudfront_origin_access_identity
      cors_allowed_headers                 = v.cors_allowed_headers == null ? var.bucket_cors_allowed_headers_default : v.cors_allowed_headers
      cors_allowed_methods                 = v.cors_allowed_methods == null ? var.bucket_cors_allowed_methods_default : v.cors_allowed_methods
      cors_allowed_origins                 = v.cors_allowed_origins == null ? var.bucket_cors_allowed_origins_default : v.cors_allowed_origins
      cors_expose_headers                  = v.cors_expose_headers == null ? var.bucket_cors_expose_headers_default : v.cors_expose_headers
      create_policy                        = v.create_policy == null ? var.bucket_create_policy_default : v.create_policy
      enable_acceleration                  = v.enable_acceleration == null ? var.bucket_enable_acceleration_default : v.enable_acceleration
      encryption_algorithm                 = v.encryption_algorithm == null ? var.bucket_encryption_algorithm_default : v.encryption_algorithm
      encryption_kms_master_key_id         = v.encryption_kms_master_key_id == null ? var.bucket_encryption_kms_master_key_id_default : v.encryption_kms_master_key_id
      encryption_disabled                  = v.encryption_disabled == null ? var.bucket_encryption_disabled_default : v.encryption_disabled
      domain_name_enabled                  = v.website_fqdn != null
      lifecycle_expiration_days            = v.lifecycle_expiration_days == null ? var.bucket_lifecycle_expiration_days_default : v.lifecycle_expiration_days
      lifecycle_upload_expiration_days     = v.lifecycle_upload_expiration_days == null ? var.bucket_lifecycle_upload_expiration_days_default : v.lifecycle_upload_expiration_days
      lifecycle_version_count              = v.lifecycle_version_count == null ? var.bucket_lifecycle_version_count_default : v.lifecycle_version_count
      lifecycle_version_expiration_days_l1 = v.lifecycle_version_expiration_days == null ? var.bucket_lifecycle_version_expiration_days_default : v.lifecycle_version_expiration_days
      notification_enable_event_bridge     = v.notification_enable_event_bridge == null ? var.bucket_notification_enable_event_bridge_default : v.notification_enable_event_bridge
      requester_pays                       = v.requester_pays == null ? var.bucket_requester_pays_default : v.requester_pays
      sid_map_l1                           = v.sid_map == null ? {} : v.sid_map
      versioning_enabled                   = v.versioning_enabled == null ? var.bucket_versioning_enabled_default : v.versioning_enabled
      website_domain                       = v.website_domain == null ? var.bucket_website_domain_default : v.website_domain
      website_enabled                      = v.website_enabled == null ? var.bucket_website_enabled_default : v.website_enabled
      website_fqdn                         = v.website_fqdn
    })
  }
  l2_map = {
    for k, _ in var.bucket_map : k => {
      lifecycle_version_expiration_days = local.l1_map[k].lifecycle_version_expiration_days_l1 == null ? local.l1_map[k].lifecycle_expiration_days : local.l1_map[k].lifecycle_version_expiration_days_l1
      sid_map_l2 = local.l1_map[k].cloudfront_origin_access_identity == null ? local.l1_map[k].sid_map_l1 : merge(local.l1_map[k].sid_map_l1, {
        CloudFront = {
          access        = "public_read"
          condition_map = {}
          identifier_list = [
            "arn:${var.std_map.iam_partition}:iam::cloudfront:user/CloudFront Origin Access Identity ${local.l1_map[k].cloudfront_origin_access_identity}",
          ]
          identifier_type = "AWS"
          object_key_list = ["*"]
        }
      })
    }
  }
  l3_map = {
    for k, _ in var.bucket_map : k => {
      sid_map = {
        for k_sid, v_sid in local.l2_map[k].sid_map_l2 : k_sid => {
          access          = v_sid.access
          condition_map   = v_sid.condition_map == null ? var.bucket_sid_condition_map_default : v_sid.condition_map
          identifier_list = v_sid.identifier_list == null ? var.bucket_sid_identifier_list_default : v_sid.identifier_list
          identifier_type = v_sid.identifier_type == null ? var.bucket_sid_identifier_type_default : v_sid.identifier_type
          object_key_list = v_sid.object_key_list == null ? var.bucket_sid_object_key_list_default : v_sid.object_key_list
        }
      }
    }
  }
  output_data = {
    for k, v in local.bucket_map : k => merge(
      {
        for k_bucket, v_bucket in v : k_bucket => v_bucket if !contains(["create_policy", "lifecycle_version_expiration_days_l1", "sid_map", "sid_map_l1", "sid_map_l2"], k_bucket)
      },
      {
        arn                     = aws_s3_bucket.this_bucket[k].arn
        bucket_domain_name      = aws_s3_bucket.this_bucket[k].bucket_regional_domain_name
        bucket_policy_doc       = v.create_policy ? module.this_bucket_policy[k].iam_policy_doc : null
        bucket_website_endpoint = aws_s3_bucket.this_bucket[k].website_endpoint
      },
    )
  }
  region_name_to_s3_dns_zone = {
    # See https://docs.aws.amazon.com/general/latest/gr/s3.html#s3_website_region_endpoints
    us-east-1    = "Z3AQBSTGFYJSTF"
    us-west-2    = "Z3BJ6K6RIION7M"
    eu-central-1 = "Z21DNDUVLTQW6Q"
    eu-south-1   = "Z30OZKI7KPW7MI"
  }
}
