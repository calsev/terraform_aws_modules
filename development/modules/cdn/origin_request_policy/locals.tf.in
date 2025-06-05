{{ name.map() }}

locals {
  l0_map = {
    for k, v in var.policy_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      cache_cookie_behavior   = v.cache_cookie_behavior == null ? var.policy_cache_cookie_behavior_default : v.cache_cookie_behavior
      cache_cookie_name_list  = v.cache_cookie_name_list == null ? var.policy_cache_cookie_name_list_default : v.cache_cookie_name_list
      cache_header_behavior   = v.cache_header_behavior == null ? var.policy_cache_header_behavior_default : v.cache_header_behavior
      cache_header_name_list  = v.cache_header_name_list == null ? var.policy_cache_header_name_list_default : v.cache_header_name_list
      cache_query_behavior    = v.cache_query_behavior == null ? var.policy_cache_query_behavior_default : v.cache_query_behavior
      cache_query_string_list = v.cache_query_string_list == null ? var.policy_cache_query_string_list_default : v.cache_query_string_list
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
    }
  }
  lx_map = {
    for k, v in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k])
  }
  output_data = {
    for k, v in local.lx_map : k => merge(
      {
        for k_attr, v_attr in v : k_attr => v_attr if !contains([], k_attr)
      },
      {
        policy_id = aws_cloudfront_origin_request_policy.this_policy[k].id
      }
    )
  }
}
