resource "aws_s3_bucket" "this_bucket" {
  for_each = local.lx_map
  bucket   = each.value.name_effective
  tags     = each.value.tags
}

resource "aws_s3_bucket_acl" "this_bucket_acl" {
  for_each = local.create_acl_map
  dynamic "access_control_policy" {
    for_each = {} # TODO
    content {
      grant {
        grantee    = null # TODO
        permission = null # TODO
      }
      owner {
        id           = null # TODO
        display_name = null # TODO
      }
    }
  }
  acl    = "private" # The ACL is either private or will be disabled
  bucket = aws_s3_bucket.this_bucket[each.key].id
  region = var.std_map.aws_region_name
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this_bucket_encryption" {
  for_each = local.lx_map
  bucket   = aws_s3_bucket.this_bucket[each.key].id
  region   = var.std_map.aws_region_name
  rule {
    dynamic "apply_server_side_encryption_by_default" {
      for_each = !each.value.encryption_disabled ? { this = {} } : {}
      content {
        sse_algorithm     = each.value.encryption_algorithm
        kms_master_key_id = each.value.encryption_kms_master_key_id
      }
    }
    blocked_encryption_types = ["SSE-C"]
    bucket_key_enabled       = true
  }
}

resource "aws_s3_bucket_versioning" "this_bucket_versioning" {
  for_each = local.lx_map
  bucket   = aws_s3_bucket.this_bucket[each.key].id
  versioning_configuration {
    mfa_delete = each.value.versioning_mfa_delete_enabled ? "Enabled" : "Disabled"
    status     = each.value.versioning_enabled ? "Enabled" : "Suspended"
  }
}

resource "aws_s3_bucket_ownership_controls" "this_bucket_ownership" {
  for_each = local.lx_map
  bucket   = aws_s3_bucket.this_bucket[each.key].id
  rule {
    object_ownership = each.value.enforce_object_ownership ? "BucketOwnerEnforced" : "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "this_public_access" {
  for_each                = local.lx_map
  block_public_acls       = !each.value.allow_public
  block_public_policy     = !each.value.allow_public
  bucket                  = aws_s3_bucket.this_bucket[each.key].id
  ignore_public_acls      = !each.value.allow_public
  restrict_public_buckets = !each.value.allow_public
}

resource "aws_s3_bucket_accelerate_configuration" "this_acceleration" {
  for_each = local.create_accelerate_map
  bucket   = aws_s3_bucket.this_bucket[each.key].id
  region   = var.std_map.aws_region_name
  status   = each.value.enable_acceleration ? "Enabled" : "Suspended"
}

resource "aws_s3_bucket_lifecycle_configuration" "this_lifecycle" {
  for_each = local.lx_map
  bucket   = aws_s3_bucket.this_bucket[each.key].id
  region   = var.std_map.aws_region_name
  rule {
    abort_incomplete_multipart_upload {
      days_after_initiation = each.value.lifecycle_upload_expiration_days
    }
    dynamic "expiration" {
      for_each = each.value.lifecycle_expiration_days == null ? {} : { this = {} }
      content {
        date                         = null
        days                         = each.value.lifecycle_expiration_days
        expired_object_delete_marker = each.value.lifecycle_expiration_delete_marker
      }
    }
    filter {
      # and
      object_size_greater_than = null
      object_size_less_than    = null
      prefix                   = ""
      # tag
    }
    id = "basic_lifetime"
    dynamic "noncurrent_version_expiration" {
      for_each = each.value.lifecycle_has_version_policy ? { this = {} } : {}
      content {
        newer_noncurrent_versions = each.value.lifecycle_version_count == 0 ? null : each.value.lifecycle_version_count
        noncurrent_days           = each.value.lifecycle_version_expiration_days
      }
    }
    dynamic "noncurrent_version_transition" {
      for_each = {}
      content {
        newer_noncurrent_versions = null
        noncurrent_days           = null
        storage_class             = null
      }
    }
    status = "Enabled"
    dynamic "transition" {
      for_each = each.value.lifecycle_transition_map_effective
      content {
        date          = transition.value.date
        days          = transition.value.days
        storage_class = transition.value.storage_class
      }
    }
  }
  transition_default_minimum_object_size = "all_storage_classes_128K"
}

resource "aws_s3_bucket_request_payment_configuration" "this_payment" {
  for_each = local.lx_map
  bucket   = aws_s3_bucket.this_bucket[each.key].id
  payer    = each.value.requester_pays ? "Requester" : "BucketOwner"
  region   = var.std_map.aws_region_name
}

resource "aws_s3_bucket_notification" "this_notification" {
  for_each    = local.lx_map
  bucket      = aws_s3_bucket.this_bucket[each.key].id
  eventbridge = each.value.notification_enable_event_bridge
  dynamic "lambda_function" {
    for_each = each.value.notification_lambda_map
    content {
      events              = lambda_function.value.event_list
      filter_prefix       = lambda_function.value.filter_prefix
      filter_suffix       = lambda_function.value.filter_suffix
      id                  = lambda_function.key
      lambda_function_arn = lambda_function.value.lambda_function_arn
    }
  }
  # queue
  # topic
}

resource "aws_s3_bucket_logging" "this_logging" {
  for_each      = local.create_log_map
  bucket        = aws_s3_bucket.this_bucket[each.key].id
  region        = var.std_map.aws_region_name
  target_bucket = each.value.log_target_bucket_name
  # target_grant # TODO
  # target_object_key_format # TODO
  # target_prefix # TODO
  target_prefix = each.value.log_target_prefix
}
