module "this_bucket_policy" {
  for_each     = local.bucket_policy_map
  depends_on   = [aws_s3_bucket.this_bucket] # This fails on new buckets
  source       = "../iam_policy_resource_s3"
  allow_public = each.value.allow_public
  bucket_name  = each.value.name_effective
  sid_map      = each.value.sid_map
  std_map      = var.std_map
}
