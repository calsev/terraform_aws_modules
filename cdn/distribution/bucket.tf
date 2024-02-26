module "cdn_origin_bucket" {
  source                           = "../../s3/bucket"
  bucket_policy_create_default     = false
  bucket_dns_from_zone_key_default = var.domain_dns_from_zone_key_default
  bucket_map                       = local.create_bucket_map
  dns_data                         = var.dns_data
  bucket_name_infix_default        = false
  std_map                          = var.std_map
}

module "bucket_policy" {
  for_each     = local.create_bucket_policy_map
  source       = "../../iam/policy/resource/s3/bucket"
  allow_public = each.value.allow_public
  bucket_name  = module.cdn_origin_bucket.data[each.key].name_effective
  sid_map      = each.value.sid_map
  std_map      = var.std_map
}
