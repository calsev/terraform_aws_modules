resource "aws_s3_bucket_cors_configuration" "this_cors" {
  for_each = local.bucket_map
  bucket   = aws_s3_bucket.this_bucket[each.key].bucket
  cors_rule {
    allowed_headers = each.value.allowed_headers
    allowed_methods = [
      "GET",
      "HEAD",
    ]
    allowed_origins = each.value.allowed_origins
    expose_headers  = []
    max_age_seconds = 3600
  }
  expected_bucket_owner = var.std_map.aws_account_id
}

resource "aws_s3_bucket_website_configuration" "this_web_config" {
  for_each = local.bucket_web_map
  bucket   = aws_s3_bucket.this_bucket[each.key].bucket
  error_document {
    key = "error.html"
  }
  expected_bucket_owner = var.std_map.aws_account_id
  index_document {
    suffix = "index.html"
  }
}

resource "aws_route53_record" "this_dns_alias" {
  for_each = local.bucket_domain_map
  alias {
    name                   = aws_s3_bucket.this_bucket[each.key].website_domain # The s3 website uses the endpoint, but the alias uses the domain and sni
    zone_id                = local.region_name_to_s3_dns_zone[var.std_map.aws_region_name]
    evaluate_target_health = false
  }
  name    = "${each.value.website_fqdn}."
  type    = "A"
  zone_id = var.dns_data.domain_to_dns_zone_map[each.value.website_domain].dns_zone_id
}
