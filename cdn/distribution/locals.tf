module "name_map" {
  source             = "../../name_map"
  name_infix_default = var.domain_name_infix_default
  name_map           = local.l0_map
  std_map            = var.std_map
}

locals {
  bucket_map = {
    for k, v in local.lx_map : v.bucket_key => {
      allow_public   = v.bucket_allow_public == null ? var.domain_bucket_allow_public_default : v.bucket_allow_public
      website_domain = v.origin_domain
      website_fqdn   = v.origin_fqdn
    }
  }
  bucket_policy_map = {
    for k, v in local.lx_map : v.bucket_key => merge(local.bucket_map[v.bucket_key], {
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
  l0_map = {
    for k, v in var.domain_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      acm_certificate_arn                                   = var.cdn_global_data.domain_cert_map[k].arn
      bucket_key                                            = replace(v.origin_fqdn, "-", "_")
      cache_policy_key                                      = v.cache_policy_key == null ? var.domain_cache_policy_key_default : v.cache_policy_key
      domain_name                                           = v.domain_name == null ? var.domain_name_default : v.domain_name
      origin_path                                           = v.origin_path == null ? var.domain_origin_path_default : v.origin_path
      origin_request_policy_key                             = v.origin_request_policy_key == null ? var.domain_origin_request_policy_key_default : v.origin_request_policy_key
      response_cors_allow_credentials                       = v.response_cors_allow_credentials == null ? var.domain_response_cors_allow_credentials_default : v.response_cors_allow_credentials
      response_cors_allowed_header_list                     = v.response_cors_allowed_header_list == null ? var.domain_response_cors_allowed_header_list_default : v.response_cors_allowed_header_list
      response_cors_allowed_method_list                     = v.response_cors_allowed_method_list == null ? var.domain_response_cors_allowed_method_list_default : v.response_cors_allowed_method_list
      response_cors_allowed_origin_list                     = v.response_cors_allowed_origin_list == null ? var.domain_response_cors_allowed_origin_list_default : v.response_cors_allowed_origin_list
      response_cors_expose_header_list                      = v.response_cors_expose_header_list == null ? var.domain_response_cors_expose_header_list_default : v.response_cors_expose_header_list
      response_cors_max_age_seconds                         = v.response_cors_max_age_seconds == null ? var.domain_response_cors_max_age_seconds_default : v.response_cors_max_age_seconds
      response_cors_origin_override                         = v.response_cors_origin_override == null ? var.domain_response_cors_origin_override_default : v.response_cors_origin_override
      response_custom_header_map                            = v.response_custom_header_map == null ? var.domain_response_custom_header_map_default : v.response_custom_header_map
      response_remove_header_list                           = v.response_remove_header_list == null ? var.domain_response_remove_header_list_default : v.response_remove_header_list
      response_security_header_content_policy               = v.response_security_header_content_policy == null ? var.domain_response_security_header_content_policy_default : v.response_security_header_content_policy
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
      trusted_key_group_key_list                            = v.trusted_key_group_key_list == null ? var.domain_trusted_key_group_key_list_default : v.trusted_key_group_key_list
      web_acl_key                                           = v.web_acl_key == null ? var.domain_web_acl_key_default : v.web_acl_key
    })
  }
  l2_map = {
    for k, v in var.domain_map : k => {
      cache_policy_id                       = var.cdn_global_data.cache_policy_map[local.l1_map[k].cache_policy_key].policy_id
      origin_request_policy_id              = var.cdn_global_data.origin_request_policy_map[local.l1_map[k].origin_request_policy_key].policy_id
      response_cors_allowed_origin_list_all = concat(local.l1_map[k].domain_name == null ? [] : ["https://${local.l1_map[k].domain_name}"], local.l1_map[k].response_cors_allowed_origin_list)
      response_custom_header_map = {
        for k_head, v_head in local.l1_map[k].response_custom_header_map : k_head => merge(v_head, {
          override = v_head.override == null ? var.domain_response_custom_header_override_default : v.override
        })
      }
      trusted_key_group_id_list = [
        for k_group in local.l1_map[k].trusted_key_group_key_list : var.key_group_data_map[k_group].group_id
      ]
      web_acl_arn = var.cdn_global_data.web_acl_map[local.l1_map[k].web_acl_key].waf_arn
    }
  }
  lx_map = {
    for k, v in var.domain_map : k => merge(local.l1_map[k], local.l2_map[k])
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
      }
    )
  }
}
