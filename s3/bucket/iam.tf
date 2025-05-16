module "this_bucket_policy" {
  for_each               = local.create_policy_resource_map
  depends_on             = [aws_s3_bucket.this_bucket] # This fails on new buckets
  source                 = "../../iam/policy/resource/s3/bucket"
  allow_access_point     = each.value.allow_access_point
  allow_config_recording = each.value.allow_config_recording
  allow_log_cloudtrail   = each.value.allow_log_cloudtrail
  allow_log_elb          = each.value.allow_log_elb
  allow_log_waf          = each.value.allow_log_waf
  allow_public           = each.value.allow_public
  bucket_name            = each.value.name_effective
  sid_map                = each.value.sid_map
  std_map                = var.std_map
}

module "identity_policy" {
  source                          = "../../iam/policy/identity/s3/bucket_access_resource"
  name_append_default             = var.name_append_default
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_prefix_default             = var.name_prefix_default
  name_prepend_default            = var.name_prepend_default
  name_suffix_default             = var.name_suffix_default
  policy_access_list_default      = var.policy_access_list_default
  policy_create_default           = var.policy_create_default
  policy_map                      = local.create_policy_identity_map
  policy_name_append_default      = var.policy_name_append_default
  policy_name_prefix_default      = var.policy_name_prefix_default
  std_map                         = var.std_map
}
