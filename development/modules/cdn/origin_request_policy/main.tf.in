resource "aws_cloudfront_origin_request_policy" "this_policy" {
  for_each = local.lx_map
  cookies_config {
    cookie_behavior = each.value.cache_cookie_behavior
    dynamic "cookies" {
      for_each = length(each.value.cache_cookie_name_list) == 0 ? {} : { this = {} }
      content {
        items = each.value.cache_cookie_name_list
      }
    }
  }
  headers_config {
    header_behavior = each.value.cache_header_behavior
    dynamic "headers" {
      for_each = length(each.value.cache_header_name_list) == 0 ? {} : { this = {} }
      content {
        items = each.value.cache_header_name_list
      }
    }
  }
  name = each.value.name_effective
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
