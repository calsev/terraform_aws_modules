module "name_map" {
  source                          = "../../name_map"
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_map                        = local.l0_map
  name_regex_allow_list           = ["."]
  std_map                         = var.std_map
}

locals {
  create_bucket_map = {
    for k, v in local.lx_map : v.bucket_key => {
      dns_enabled  = v.origin_dns_enabled
      allow_public = v.origin_allow_public
    }
  }
  create_bucket_policy_map = {
    for k, v in local.lx_map : v.bucket_key => merge(local.create_bucket_map[v.bucket_key], {
      sid_map = merge(
        v.sid_map,
        {
          Cloudfront = {
            access = "public_read"
            condition_map = {
              cloudfront_distribution = {
                test       = "StringEquals"
                value_list = [aws_cloudfront_distribution.this_distribution[k].arn]
                variable   = "AWS:SourceArn"
              }
            }
            identifier_list = ["cloudfront.amazonaws.com"]
            identifier_type = "Service"
          }
        },
      )
    })
  }
  create_alias_1_list = flatten([
    for k, v in local.lx_map : [
      for alias in v.alias_name_list_final : merge(v, {
        dns_alias_name    = aws_cloudfront_distribution.this_distribution[k].domain_name
        dns_alias_zone_id = aws_cloudfront_distribution.this_distribution[k].hosted_zone_id
        dns_from_fqdn     = alias
        k_dns             = "${k}_${alias}"
      })
    ]
  ])
  create_alias_x_map = {
    for v in local.create_alias_1_list : v.k_dns => v
  }
  l0_map = {
    for k, v in var.domain_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      bucket_key                                            = replace(v.origin_fqdn, "-", "_")
      cache_policy_key                                      = v.cache_policy_key == null ? var.domain_cache_policy_key_default : v.cache_policy_key
      cache_viewer_protocol_policy                          = v.cache_viewer_protocol_policy == null ? var.domain_cache_viewer_protocol_policy_default : v.cache_viewer_protocol_policy
      default_root_object                                   = v.default_root_object == null ? var.domain_default_root_object_default : v.default_root_object
      dns_alias_enabled                                     = v.dns_alias_enabled == null ? var.domain_dns_alias_enabled_default : v.dns_alias_enabled
      dns_alias_san_list                                    = v.dns_alias_san_list == null ? var.domain_dns_alias_san_list_default : v.dns_alias_san_list
      dns_from_zone_key                                     = v.dns_from_zone_key == null ? var.domain_dns_from_zone_key_default : v.dns_from_zone_key
      enabled                                               = v.enabled == null ? var.domain_enabled_default : v.enabled
      http_version_max_supported                            = v.http_version_max_supported == null ? var.domain_http_version_max_supported_default : v.http_version_max_supported
      ipv6_enabled                                          = v.ipv6_enabled == null ? var.domain_ipv6_enabled_default : v.ipv6_enabled
      logging_bucket_key                                    = v.logging_bucket_key == null ? var.domain_logging_bucket_key_default : v.logging_bucket_key
      logging_include_cookies                               = v.logging_include_cookies == null ? var.domain_logging_include_cookies_default : v.logging_include_cookies
      logging_object_prefix                                 = v.logging_object_prefix == null ? var.domain_logging_object_prefix_default : v.logging_object_prefix
      origin_allow_public                                   = v.origin_allow_public == null ? var.domain_origin_allow_public_default : v.origin_allow_public
      origin_connection_attempts                            = v.origin_connection_attempts == null ? var.domain_origin_connection_attempts_default : v.origin_connection_attempts
      origin_connection_timeout_seconds                     = v.origin_connection_timeout_seconds == null ? var.domain_origin_connection_timeout_seconds_default : v.origin_connection_timeout_seconds
      origin_dns_enabled                                    = v.origin_dns_enabled == null ? var.domain_origin_dns_enabled_default : v.origin_dns_enabled
      origin_fqdn                                           = replace(v.origin_fqdn, "_", "-")
      origin_path                                           = v.origin_path == null ? var.domain_origin_path_default : v.origin_path
      origin_request_policy_key                             = v.origin_request_policy_key == null ? var.domain_origin_request_policy_key_default : v.origin_request_policy_key
      price_class                                           = v.price_class == null ? var.domain_price_class_default : v.price_class
      response_cors_allow_credentials                       = v.response_cors_allow_credentials == null ? var.domain_response_cors_allow_credentials_default : v.response_cors_allow_credentials
      response_cors_allowed_header_list                     = v.response_cors_allowed_header_list == null ? var.domain_response_cors_allowed_header_list_default : v.response_cors_allowed_header_list
      response_cors_allowed_method_list                     = v.response_cors_allowed_method_list == null ? var.domain_response_cors_allowed_method_list_default : v.response_cors_allowed_method_list
      response_cors_allowed_origin_list                     = [for origin in v.response_cors_allowed_origin_list == null ? var.domain_response_cors_allowed_origin_list_default : v.response_cors_allowed_origin_list : startswith(origin, "http") ? origin : "https://${origin}"]
      response_cors_expose_header_list                      = v.response_cors_expose_header_list == null ? var.domain_response_cors_expose_header_list_default : v.response_cors_expose_header_list
      response_cors_max_age_seconds                         = v.response_cors_max_age_seconds == null ? var.domain_response_cors_max_age_seconds_default : v.response_cors_max_age_seconds
      response_cors_origin_override                         = v.response_cors_origin_override == null ? var.domain_response_cors_origin_override_default : v.response_cors_origin_override
      response_custom_header_map                            = v.response_custom_header_map == null ? var.domain_response_custom_header_map_default : v.response_custom_header_map
      response_remove_header_list                           = v.response_remove_header_list == null ? var.domain_response_remove_header_list_default : v.response_remove_header_list
      response_security_header_content_policy_origin_map    = v.response_security_header_content_policy_origin_map == null ? var.domain_response_security_header_content_policy_origin_map_default : v.response_security_header_content_policy_origin_map
      response_security_header_content_override             = v.response_security_header_content_override == null ? var.domain_response_security_header_content_override_default : v.response_security_header_content_override
      response_security_header_content_type_override        = v.response_security_header_content_type_override == null ? var.domain_response_security_header_content_type_override_default : v.response_security_header_content_type_override
      response_security_header_frame_option                 = v.response_security_header_frame_option == null ? var.domain_response_security_header_frame_option_default : v.response_security_header_frame_option
      response_security_header_frame_override               = v.response_security_header_frame_override == null ? var.domain_response_security_header_frame_override_default : v.response_security_header_frame_override
      response_security_header_referrer_override            = v.response_security_header_referrer_override == null ? var.domain_response_security_header_referrer_override_default : v.response_security_header_referrer_override
      response_security_header_referrer_policy              = v.response_security_header_referrer_policy == null ? var.domain_response_security_header_referrer_policy_default : v.response_security_header_referrer_policy
      response_security_header_transport_max_age_seconds    = v.response_security_header_transport_max_age_seconds == null ? var.domain_response_security_header_transport_max_age_seconds_default : v.response_security_header_transport_max_age_seconds
      response_security_header_transport_include_subdomains = v.response_security_header_transport_include_subdomains == null ? var.domain_response_security_header_transport_include_subdomains_default : v.response_security_header_transport_include_subdomains
      response_security_header_transport_override           = v.response_security_header_transport_override == null ? var.domain_response_security_header_transport_override_default : v.response_security_header_transport_override
      response_security_header_transport_preload            = v.response_security_header_transport_preload == null ? var.domain_response_security_header_transport_preload_default : v.response_security_header_transport_preload
      response_server_timing_enabled                        = v.response_server_timing_enabled == null ? var.domain_response_server_timing_enabled_default : v.response_server_timing_enabled
      response_server_timing_sampling_rate                  = v.response_server_timing_sampling_rate == null ? var.domain_response_server_timing_sampling_rate_default : v.response_server_timing_sampling_rate
      retain_on_delete                                      = v.retain_on_delete == null ? var.domain_retain_on_delete_default : v.retain_on_delete
      smooth_streaming_enabled                              = v.smooth_streaming_enabled == null ? var.domain_smooth_streaming_enabled_default : v.smooth_streaming_enabled
      trusted_key_group_key_list                            = v.trusted_key_group_key_list == null ? var.domain_trusted_key_group_key_list_default : v.trusted_key_group_key_list
      wait_for_deployment                                   = v.wait_for_deployment == null ? var.domain_wait_for_deployment_default : v.wait_for_deployment
      web_acl_key                                           = v.web_acl_key == null ? var.domain_web_acl_key_default : v.web_acl_key
    })
  }
  l2_map = {
    for k, v in var.domain_map : k => {
      acm_certificate_arn         = local.l1_map[k].dns_alias_enabled ? var.cdn_global_data.domain_cert_map[k].certificate_arn : null
      acm_certificate_use_default = !local.l1_map[k].dns_alias_enabled
      alias_name_list             = concat([local.l1_map[k].name_simple], local.l1_map[k].dns_alias_san_list)
      cache_policy_id             = var.cdn_global_data.cache_policy_map[local.l1_map[k].cache_policy_key].policy_id
      logging_bucket_name         = local.l1_map[k].logging_bucket_key == null ? null : var.s3_data_map[local.l1_map[k].logging_bucket_key].name_effective
      origin_request_policy_id    = var.cdn_global_data.origin_request_policy_map[local.l1_map[k].origin_request_policy_key].policy_id
      response_custom_header_map = {
        for k_head, v_head in local.l1_map[k].response_custom_header_map : k_head => merge(v_head, {
          override = v_head.override == null ? var.domain_response_custom_header_override_default : v.override
        })
      }
      response_security_header_content_policy_origin_map_all = {
        for k_src, v_src in local.l1_map[k].response_security_header_content_policy_origin_map : k_src => concat(["'self'", "https://${local.l1_map[k].dns_from_zone_key}"], v_src)
      }
      trusted_key_group_id_list = [
        for k_group in local.l1_map[k].trusted_key_group_key_list : var.key_group_data_map[k_group].group_id
      ]
      viewer_certificate_minimum_protocol_version = local.l1_map[k].dns_alias_enabled ? v.viewer_certificate_minimum_protocol_version == null ? var.domain_viewer_certificate_minimum_protocol_version_default : v.viewer_certificate_minimum_protocol_version : null
      viewer_certificate_ssl_support_method       = local.l1_map[k].dns_alias_enabled ? v.viewer_certificate_ssl_support_method == null ? var.domain_viewer_certificate_ssl_support_method_default : v.viewer_certificate_ssl_support_method : null
      web_acl_arn                                 = var.cdn_global_data.web_acl_map[local.l1_map[k].web_acl_key].waf_acl_arn
    }
  }
  l3_map = {
    for k, v in var.domain_map : k => {
      alias_name_list_final                 = local.l1_map[k].dns_alias_enabled ? local.l2_map[k].alias_name_list : []
      response_cors_allowed_origin_list_all = concat([for fqdn in local.l2_map[k].alias_name_list : "https://${fqdn}"], local.l1_map[k].response_cors_allowed_origin_list) # Include aliases even without DNS enabled
      response_security_header_content_policy_final = join(" ", [
        for k_src, v_src in local.l2_map[k].response_security_header_content_policy_origin_map_all : "${k_src} ${join(" ", v_src)};"
      ])
    }
  }
  lx_map = {
    for k, v in var.domain_map : k => merge(local.l1_map[k], local.l2_map[k], local.l3_map[k])
  }
  output_data = {
    for k, v in local.lx_map : k => merge(
      v,
      {
        bucket = merge(
          module.cdn_origin_bucket.data[v.bucket_key],
          {
            bucket_policy_doc = module.bucket_policy[v.bucket_key].iam_policy_doc
          },
        )
        cdn_arn = aws_cloudfront_distribution.this_distribution[k].arn
        cdn_id  = aws_cloudfront_distribution.this_distribution[k].id
        dns_alias = {
          for alias in v.alias_name_list_final : "${k}_${alias}" => module.this_dns_alias.data["${k}_${alias}"]
        }
      }
    )
  }
}
