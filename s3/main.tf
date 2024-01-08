resource "aws_s3_bucket" "this_bucket" {
  for_each = local.bucket_map
  bucket   = each.value.name_effective
  tags     = each.value.tags
}

resource "aws_s3_bucket_acl" "this_bucket_acl" {
  for_each              = local.bucket_map
  acl                   = "private" # The ACL is either private or will be disabled
  bucket                = aws_s3_bucket.this_bucket[each.key].id
  expected_bucket_owner = var.std_map.aws_account_id
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this_bucket_encryption" {
  for_each              = local.bucket_map
  bucket                = aws_s3_bucket.this_bucket[each.key].id
  expected_bucket_owner = var.std_map.aws_account_id
  rule {
    dynamic "apply_server_side_encryption_by_default" {
      for_each = !each.value.encryption_disabled ? { this = {} } : {}
      content {
        sse_algorithm     = each.value.encryption_algorithm
        kms_master_key_id = each.value.encryption_kms_master_key_id
      }
    }
    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_versioning" "this_bucket_versioning" {
  for_each = local.bucket_map
  bucket   = aws_s3_bucket.this_bucket[each.key].id
  versioning_configuration {
    mfa_delete = "Disabled"
    status     = each.value.versioning_enabled ? "Enabled" : "Suspended"
  }
}

resource "aws_s3_bucket_ownership_controls" "this_bucket_ownership" {
  for_each = local.bucket_map
  bucket   = aws_s3_bucket.this_bucket[each.key].id
  # This will disable creation of the ACL
  depends_on = [
    aws_s3_bucket_acl.this_bucket_acl,
  ]
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "this_public_access" {
  for_each                = local.bucket_map
  block_public_acls       = !each.value.allow_public
  block_public_policy     = !each.value.allow_public
  bucket                  = aws_s3_bucket.this_bucket[each.key].id
  ignore_public_acls      = !each.value.allow_public
  restrict_public_buckets = !each.value.allow_public
}

resource "aws_s3_bucket_accelerate_configuration" "this_acceleration" {
  for_each              = local.bucket_accelerate_map
  bucket                = aws_s3_bucket.this_bucket[each.key].id
  expected_bucket_owner = var.std_map.aws_account_id
  status                = each.value.enable_acceleration ? "Enabled" : "Suspended"
}

resource "aws_s3_bucket_lifecycle_configuration" "this_lifecycle" {
  for_each              = local.bucket_map
  bucket                = aws_s3_bucket.this_bucket[each.key].id
  expected_bucket_owner = var.std_map.aws_account_id
  rule {
    abort_incomplete_multipart_upload {
      days_after_initiation = each.value.lifecycle_upload_expiration_days
    }
    dynamic "expiration" {
      for_each = each.value.lifecycle_expiration_days == null ? {} : { this = {} }
      content {
        days = each.value.lifecycle_expiration_days
      }
    }
    id = "basic_lifetime"
    dynamic "noncurrent_version_expiration" {
      for_each = each.value.lifecycle_version_count == null && each.value.lifecycle_version_expiration_days == null ? {} : { this = {} }
      content {
        newer_noncurrent_versions = each.value.lifecycle_version_count
        noncurrent_days           = each.value.lifecycle_version_expiration_days
      }
    }
    status = "Enabled"
  }
}

resource "aws_s3_bucket_request_payment_configuration" "this_payment" {
  for_each              = local.bucket_map
  bucket                = aws_s3_bucket.this_bucket[each.key].id
  expected_bucket_owner = var.std_map.aws_account_id
  payer                 = each.value.requester_pays ? "Requester" : "BucketOwner"
}

resource "aws_s3_bucket_notification" "this_notification" {
  for_each    = local.bucket_map
  bucket      = aws_s3_bucket.this_bucket[each.key].id
  eventbridge = each.value.notification_enable_event_bridge
}

module "this_bucket_policy" {
  for_each     = local.bucket_policy_map
  depends_on   = [aws_s3_bucket.this_bucket] # This fails on new buckets
  source       = "../iam/policy/resource/s3"
  allow_public = each.value.allow_public
  bucket_name  = each.value.name_effective
  sid_map      = each.value.sid_map
  std_map      = var.std_map
}
