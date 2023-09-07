locals {
  bucket_map = {
    for k, v in var.domain_map : v.origin_fqdn => {
      allow_public   = v.bucket_allow_public == null ? var.domain_bucket_allow_public_default : v.bucket_allow_public
      website_domain = v.origin_domain
      website_fqdn   = v.origin_fqdn
    }
  }
  bucket_policy_map = {
    for k, v in var.domain_map : v.origin_fqdn => merge(local.bucket_map[v.origin_fqdn], {
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
  domain_map = {
    for k, v in var.domain_map : k => merge(v, {
      acm_certificate_arn = var.cdn_global_data.cert[k].arn
      domain_name         = v.domain_name == null ? var.domain_name_default : v.domain_name
      origin_path         = v.origin_path == null ? var.domain_origin_path_default : v.origin_path
    })
  }
  tags = {
    for k, _ in var.domain_map : k => merge(
      var.std_map.tags,
      {
        Name = "${var.std_map.resource_name_prefix}${k}${var.std_map.resource_name_suffix}"
      }
    )
  }
}
