
resource "aws_cloudfront_cache_policy" "cdn_cache_policy_max_cache" {
  default_ttl = 60 * 60 * 24
  max_ttl     = 60 * 60 * 24 * 365
  min_ttl     = 60 * 60 * 24
  name        = "CdnCachePolicyMaxCache"
  parameters_in_cache_key_and_forwarded_to_origin {
    enable_accept_encoding_brotli = true
    enable_accept_encoding_gzip   = true
    cookies_config {
      cookie_behavior = "none"
    }
    headers_config {
      header_behavior = "none"
    }
    query_strings_config {
      query_string_behavior = "none"
    }
  }
}

resource "aws_cloudfront_origin_request_policy" "cdn_origin_policy_max_cache" {
  cookies_config {
    cookie_behavior = "none"
  }
  headers_config {
    header_behavior = "none"
  }
  name = "CdnOriginPolicyMaxCache"
  query_strings_config {
    query_string_behavior = "none"
  }
}
