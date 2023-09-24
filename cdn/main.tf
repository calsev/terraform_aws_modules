resource "aws_cloudfront_origin_access_control" "this_origin_control" {
  for_each                          = var.domain_map
  name                              = each.key
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "this_distribution" {
  for_each = local.domain_map
  aliases  = [each.key]
  default_cache_behavior {
    allowed_methods = [
      "GET",
      "HEAD",
      "OPTIONS",
    ]
    cached_methods = [
      "GET",
      "HEAD",
      "OPTIONS",
    ]
    cache_policy_id          = var.cdn_global_data.cache_policy_id_map.max_cache
    compress                 = true
    origin_request_policy_id = var.cdn_global_data.origin_request_policy_id_map.max_cache
    target_origin_id         = each.value.origin_fqdn
    viewer_protocol_policy   = "redirect-to-https"
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
  tags = local.tags[each.key]
  viewer_certificate {
    acm_certificate_arn      = each.value.acm_certificate_arn
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method       = "sni-only"
  }
  web_acl_id = var.cdn_global_data.web_acl_arn
}

resource "aws_route53_record" "this_dns_alias" {
  for_each = local.domain_map
  alias {
    evaluate_target_health = false
    name                   = aws_cloudfront_distribution.this_distribution[each.key].domain_name
    zone_id                = aws_cloudfront_distribution.this_distribution[each.key].hosted_zone_id
  }
  name    = "${each.key}."
  type    = "A"
  zone_id = var.dns_data.domain_to_dns_zone_map[each.value.domain_name].dns_zone_id
}
