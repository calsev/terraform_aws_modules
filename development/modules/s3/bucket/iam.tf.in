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

{{ iam.policy_identity_ar_type(policy_name="identity_policy", map="create_policy_identity_map", suffix="s3/bucket_access_resource") }}
