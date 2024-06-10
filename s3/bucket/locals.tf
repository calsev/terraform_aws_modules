module "name_map" {
  source                          = "../../name_map"
  name_include_app_fields_default = var.bucket_name_include_app_fields_default
  name_infix_default              = var.bucket_name_infix_default
  name_map                        = local.l0_map
  name_regex_allow_list           = ["."] # Do not replace "." in domain names
  std_map                         = var.std_map
  tags_default                    = var.bucket_tags_default
}

locals {
  create_accelerate_map = {
    for k, v in local.lx_map : k => v if v.acceleration_enabled
  }
  create_acl_map = {
    for k, v in local.lx_map : k => v if !v.enforce_object_ownership
  }
  create_alias_map = {
    for k, v in local.lx_map : k => merge(v, {
      dns_alias_name    = aws_s3_bucket.this_bucket[k].website_domain # The s3 website uses the endpoint, but the alias uses the domain and sni
      dns_alias_zone_id = aws_s3_bucket.this_bucket[k].hosted_zone_id
    }) if v.dns_enabled
  }
  create_log_map = {
    for k, v in local.lx_map : k => v if v.log_target_bucket_name != null
  }
  create_owner_map = {
    for k, v in local.lx_map : k => v if v.enforce_object_ownership
  }
  create_policy_identity_map = {
    for k, v in local.lx_map : k => v if v.policy_identity_create
  }
  create_policy_resource_map = {
    for k, v in local.lx_map : k => v if v.policy_resource_create
  }
  create_web_map = {
    for k, v in local.lx_map : k => v if v.website_enabled
  }
  l0_map = {
    for k, v in var.bucket_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      allow_access_point                   = v.allow_access_point == null ? var.bucket_allow_access_point_default : v.allow_access_point
      allow_service_logging                = v.allow_service_logging == null ? var.bucket_allow_service_logging_default : v.allow_service_logging
      acceleration_enabled                 = length(split(".", k)) == 1 # TODO: Why not dot buckets?
      allow_public                         = v.allow_public == null ? var.bucket_allow_public_default : v.allow_public
      cloudfront_origin_access_identity    = v.cloudfront_origin_access_identity
      cors_allowed_headers                 = v.cors_allowed_headers == null ? var.bucket_cors_allowed_headers_default : v.cors_allowed_headers
      cors_allowed_methods                 = v.cors_allowed_methods == null ? var.bucket_cors_allowed_methods_default : v.cors_allowed_methods
      cors_allowed_origins                 = v.cors_allowed_origins == null ? var.bucket_cors_allowed_origins_default : v.cors_allowed_origins
      cors_expose_headers                  = v.cors_expose_headers == null ? var.bucket_cors_expose_headers_default : v.cors_expose_headers
      dns_enabled                          = v.dns_enabled == null ? var.bucket_dns_enabled_default : v.dns_enabled
      dns_from_zone_key                    = v.dns_from_zone_key == null ? var.bucket_dns_from_zone_key_default : v.dns_from_zone_key
      enable_acceleration                  = v.enable_acceleration == null ? var.bucket_enable_acceleration_default : v.enable_acceleration
      encryption_algorithm                 = v.encryption_algorithm == null ? var.bucket_encryption_algorithm_default : v.encryption_algorithm
      encryption_kms_master_key_id         = v.encryption_kms_master_key_id == null ? var.bucket_encryption_kms_master_key_id_default : v.encryption_kms_master_key_id
      encryption_disabled                  = v.encryption_disabled == null ? var.bucket_encryption_disabled_default : v.encryption_disabled
      enforce_object_ownership             = v.enforce_object_ownership == null ? var.bucket_enforce_object_ownership_default : v.enforce_object_ownership
      lifecycle_expiration_days            = v.lifecycle_expiration_days == null ? var.bucket_lifecycle_expiration_days_default : v.lifecycle_expiration_days
      lifecycle_upload_expiration_days     = v.lifecycle_upload_expiration_days == null ? var.bucket_lifecycle_upload_expiration_days_default : v.lifecycle_upload_expiration_days
      lifecycle_transition_map             = v.lifecycle_transition_map == null ? var.bucket_lifecycle_transition_map_default : v.lifecycle_transition_map
      lifecycle_version_count              = v.lifecycle_version_count == null ? var.bucket_lifecycle_version_count_default : v.lifecycle_version_count
      lifecycle_version_expiration_days_l1 = v.lifecycle_version_expiration_days == null ? var.bucket_lifecycle_version_expiration_days_default : v.lifecycle_version_expiration_days
      log_target_bucket_name               = v.log_target_bucket_name == null ? var.bucket_log_target_bucket_name_default : v.log_target_bucket_name
      log_target_prefix                    = v.log_target_prefix == null ? var.bucket_log_target_prefix_default : v.log_target_prefix
      notification_enable_event_bridge     = v.notification_enable_event_bridge == null ? var.bucket_notification_enable_event_bridge_default : v.notification_enable_event_bridge
      policy_identity_create               = v.policy_identity_create == null ? var.bucket_policy_identity_create_default : v.policy_identity_create
      policy_resource_create               = v.policy_resource_create == null ? var.bucket_policy_resource_create_default : v.policy_resource_create
      requester_pays                       = v.requester_pays == null ? var.bucket_requester_pays_default : v.requester_pays
      sid_map_l1                           = v.sid_map == null ? {} : v.sid_map
      versioning_enabled                   = v.versioning_enabled == null ? var.bucket_versioning_enabled_default : v.versioning_enabled
      website_enabled                      = v.website_enabled == null ? var.bucket_website_enabled_default : v.website_enabled
    })
  }
  l2_map = {
    for k, _ in local.l0_map : k => {
      lifecycle_transition_map = {
        for k_life, v_life in local.l1_map[k].lifecycle_transition_map : k_life => merge(v_life, {
          date          = v_life.date == null ? var.bucket_lifecycle_transition_date_default : v_life.date
          days          = v_life.days == null ? var.bucket_lifecycle_transition_days_default : v_life.days
          storage_class = v_life.storage_class == null ? var.bucket_lifecycle_transition_storage_class_default : v_life.storage_class
        })
      }
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
    for k, _ in local.l0_map : k => {
      lifecycle_transition_map_effective = {
        for k_life, v_life in local.l2_map[k].lifecycle_transition_map : k_life => v_life if(
          local.l1_map[k].lifecycle_expiration_days == null || v_life.date != null ? true : ( # If objects never expire then include all rules; punt for dates
            v_life.days == null ? local.l1_map[k].lifecycle_expiration_days > 30 : (          # Default is day 0, so min 30 days later for intelligent tiering to IA
              v_life.days + 30 < local.l1_map[k].lifecycle_expiration_days                    # Ditto for min 30 day wait
            )
          )
        )
      }
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
  lx_map = {
    for k, v in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k], local.l3_map[k])
  }
  output_data = {
    for k, v in local.lx_map : k => merge(
      {
        for k_bucket, v_bucket in v : k_bucket => v_bucket if !contains(["policy_create", "lifecycle_version_expiration_days_l1", "sid_map", "sid_map_l1", "sid_map_l2"], k_bucket)
      },
      {
        arn                     = aws_s3_bucket.this_bucket[k].arn
        bucket_domain_name      = aws_s3_bucket.this_bucket[k].bucket_regional_domain_name
        bucket_policy_doc       = v.policy_resource_create ? module.this_bucket_policy[k].iam_policy_doc : null
        bucket_website_endpoint = aws_s3_bucket.this_bucket[k].website_endpoint
        dns_alias               = v.dns_enabled ? module.dns_alias.data[k] : null
        policy                  = v.policy_identity_create ? module.identity_policy[k].data : null
      },
    )
  }
}
