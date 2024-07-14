resource "aws_s3_bucket_cors_configuration" "this_cors" {
  for_each = local.create_cors_map
  bucket   = aws_s3_bucket.this_bucket[each.key].bucket
  cors_rule {
    allowed_headers = each.value.cors_allowed_headers
    allowed_methods = each.value.cors_allowed_methods
    allowed_origins = each.value.cors_allowed_origins
    expose_headers  = each.value.cors_expose_headers
    max_age_seconds = 3600
  }
  expected_bucket_owner = var.std_map.aws_account_id
}

resource "aws_s3_bucket_website_configuration" "this_web_config" {
  for_each = local.create_web_map
  bucket   = aws_s3_bucket.this_bucket[each.key].bucket
  error_document {
    key = "error.html"
  }
  expected_bucket_owner = var.std_map.aws_account_id
  index_document {
    suffix = "index.html"
  }
}

module "dns_alias" {
  source                           = "../../dns/record"
  dns_data                         = var.dns_data
  record_dns_from_zone_key_default = var.bucket_dns_from_zone_key_default
  record_map                       = local.create_alias_map
  std_map                          = var.std_map
}
