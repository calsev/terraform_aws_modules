locals {
  bucket_map = {
    for k, v in var.domain_map : v.origin_fqdn => {
      website_domain = v.origin_domain
      website_fqdn   = v.origin_fqdn
    }
  }
  bucket_policy_map = {
    for k, v in var.domain_map : v.origin_fqdn => merge(v.sid_map == null ? {} : v.sid_map, {
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
