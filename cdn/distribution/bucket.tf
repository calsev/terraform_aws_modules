module "cdn_origin_bucket" {
  source                                           = "../../s3/bucket"
  bucket_dns_from_zone_key_default                 = var.domain_dns_from_zone_key_default
  bucket_map                                       = local.create_bucket_map
  bucket_notification_lambda_event_list_default    = var.bucket_notification_lambda_event_list_default
  bucket_notification_lambda_filter_prefix_default = var.bucket_notification_lambda_filter_prefix_default
  bucket_notification_lambda_filter_suffix_default = var.bucket_notification_lambda_filter_suffix_default
  bucket_notification_lambda_function_arn_default  = var.bucket_notification_lambda_function_arn_default
  bucket_policy_resource_create_default            = false
  dns_data                                         = var.dns_data
  bucket_log_target_bucket_name_default            = var.bucket_log_target_bucket_name_default
  name_infix_default                               = false
  std_map                                          = var.std_map
}

module "bucket_policy" {
  for_each     = local.create_bucket_policy_map
  source       = "../../iam/policy/resource/s3/bucket"
  allow_public = each.value.allow_public
  bucket_name  = module.cdn_origin_bucket.data[each.key].name_effective
  sid_map      = each.value.sid_map
  std_map      = var.std_map
}
