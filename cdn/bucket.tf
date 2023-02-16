module "cdn_origin_bucket" {
  source = "../s3"

  bucket_create_policy_default = false
  bucket_map                   = local.bucket_map
  dns_data                     = var.dns_data
  bucket_name_infix_default    = false
  std_map                      = var.std_map
}

module "bucket_policy" {
  for_each     = local.bucket_policy_map
  source       = "../iam_policy_resource_s3"
  allow_public = each.value.allow_public
  bucket_name  = module.cdn_origin_bucket.data[each.key].bucket_name
  sid_map      = each.value.sid_map
  std_map      = var.std_map
}
