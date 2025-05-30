resource "aws_cloudfront_cache_policy" "this_policy" {
  for_each    = local.lx_map
  default_ttl = each.value.ttl_default_second
  max_ttl     = each.value.ttl_max_second
  min_ttl     = each.value.ttl_min_second
  name        = each.value.name_effective
  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config {
      cookie_behavior = each.value.cache_cookie_behavior
      dynamic "cookies" {
        for_each = length(each.value.cache_cookie_name_list) == 0 ? {} : { this = {} }
        content {
          items = each.value.cache_cookie_name_list
        }
      }
    }
    enable_accept_encoding_brotli = each.value.cache_accept_encoding_brotli
    enable_accept_encoding_gzip   = each.value.cache_accept_encoding_gzip
    headers_config {
      header_behavior = each.value.cache_header_behavior
      dynamic "headers" {
        for_each = length(each.value.cache_header_name_list) == 0 ? {} : { this = {} }
        content {
          items = each.value.cache_header_name_list
        }
      }
    }
    query_strings_config {
      query_string_behavior = each.value.cache_query_behavior
      dynamic "query_strings" {
        for_each = length(each.value.cache_query_string_list) == 0 ? {} : { this = {} }
        content {
          items = each.value.cache_query_string_list
        }
      }
    }
  }
}
