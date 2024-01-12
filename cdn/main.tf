resource "aws_cloudfront_origin_access_control" "this_origin_control" {
  for_each                          = var.domain_map
  name                              = each.key
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_response_headers_policy" "header_policy" {
  for_each = local.lx_map
  cors_config {
    access_control_allow_credentials = each.value.response_cors_allow_credentials
    access_control_allow_headers {
      items = each.value.response_cors_allowed_header_list
    }
    access_control_allow_methods {
      items = each.value.response_cors_allowed_method_list
    }
    access_control_allow_origins {
      items = each.value.response_cors_allowed_origin_list_all
    }
    access_control_expose_headers {
      items = each.value.response_cors_expose_header_list
    }
    access_control_max_age_sec = each.value.response_cors_max_age_seconds
    origin_override            = each.value.response_cors_origin_override
  }
  dynamic "custom_headers_config" {
    for_each = length(each.value.response_custom_header_map) > 0 ? { this = {} } : {}
    content {
      dynamic "items" {
        for_each = each.value.response_custom_header_map
        content {
          header   = items.key
          override = items.value.override
          value    = items.value.value
        }
      }
    }
  }
  name = each.value.name_effective
  remove_headers_config {
    dynamic "items" {
      for_each = each.value.response_remove_header_list
      content {
        header = each.value
      }
    }
  }
  security_headers_config {
    content_security_policy {
      content_security_policy = each.value.response_security_header_content_policy
      override                = each.value.response_security_header_content_override
    }
    content_type_options {
      override = each.value.response_security_header_content_type_override
    }
    frame_options {
      frame_option = each.value.response_security_header_frame_option
      override     = each.value.response_security_header_frame_override
    }
    referrer_policy {
      override        = each.value.response_security_header_referrer_override
      referrer_policy = each.value.response_security_header_referrer_policy
    }
    strict_transport_security {
      access_control_max_age_sec = each.value.response_security_header_transport_max_age_seconds
      include_subdomains         = each.value.response_security_header_transport_include_subdomains
      override                   = each.value.response_security_header_transport_override
      preload                    = each.value.response_security_header_transport_preload
    }
    #xss_protection Obsolete, see https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-XSS-Protection
  }
  server_timing_headers_config {
    enabled       = each.value.response_server_timing_enabled
    sampling_rate = each.value.response_server_timing_sampling_rate
  }
}

resource "aws_cloudfront_distribution" "this_distribution" {
  for_each = local.lx_map
  aliases  = [each.key]
  default_cache_behavior {
    allowed_methods           = each.value.response_cors_allowed_method_list
    cached_methods            = each.value.response_cors_allowed_method_list
    cache_policy_id           = var.cdn_global_data.cache_policy_id_map.max_cache # TODO
    compress                  = true
    default_ttl               = null
    field_level_encryption_id = null
    #function_association
    #lambda_function_association
    max_ttl                    = null
    min_ttl                    = null
    origin_request_policy_id   = var.cdn_global_data.origin_request_policy_id_map.max_cache
    realtime_log_config_arn    = null
    response_headers_policy_id = aws_cloudfront_response_headers_policy.header_policy[each.key].id
    smooth_streaming           = false # TODO
    target_origin_id           = each.value.origin_fqdn
    trusted_key_groups         = []                  # TODO
    trusted_signers            = []                  # TODO
    viewer_protocol_policy     = "redirect-to-https" # TODO
  }
  default_root_object = "index.html"
  enabled             = true
  is_ipv6_enabled     = true
  origin {
    domain_name              = module.cdn_origin_bucket.data[each.value.origin_fqdn].bucket_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.this_origin_control[each.key].id
    origin_id                = each.value.origin_fqdn
    origin_path              = each.value.origin_path
    #    origin_shield  # Not needed with S3 site
  }
  price_class = "PriceClass_All"
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  tags = each.value.tags
  viewer_certificate {
    acm_certificate_arn      = each.value.acm_certificate_arn
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method       = "sni-only"
  }
  web_acl_id = var.cdn_global_data.web_acl_arn
}

resource "aws_route53_record" "this_dns_alias" {
  for_each = local.lx_map
  alias {
    evaluate_target_health = false
    name                   = aws_cloudfront_distribution.this_distribution[each.key].domain_name
    zone_id                = aws_cloudfront_distribution.this_distribution[each.key].hosted_zone_id
  }
  name    = "${each.key}."
  type    = "A"
  zone_id = var.dns_data.domain_to_dns_zone_map[each.value.domain_name].dns_zone_id
}
