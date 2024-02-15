resource "aws_s3_access_point" "this_ap" {
  for_each          = local.ap_map
  account_id        = var.std_map.aws_account_id
  bucket            = each.value.bucket_name_effective
  bucket_account_id = var.std_map.aws_account_id
  name              = each.value.name_effective
  # policy
  public_access_block_configuration {
    block_public_acls       = !each.value.allow_public
    block_public_policy     = !each.value.allow_public
    ignore_public_acls      = !each.value.allow_public
    restrict_public_buckets = !each.value.allow_public
  }
  dynamic "vpc_configuration" {
    for_each = each.value.vpc_key == null ? {} : { this = {} }
    content {
      vpc_id = each.value.vpc_id
    }
  }
}

module "this_bucket_policy" {
  for_each      = local.ap_policy_map
  source        = "../../iam/policy/resource/s3/bucket"
  allow_public  = each.value.allow_public
  bucket_name   = aws_s3_access_point.this_ap[each.key].arn
  policy_create = false
  sid_map       = each.value.sid_map
  std_map       = var.std_map
}

resource "aws_s3control_access_point_policy" "this_policy" {
  for_each         = local.ap_policy_map
  access_point_arn = aws_s3_access_point.this_ap[each.key].arn
  policy           = jsonencode(module.this_bucket_policy[each.key].iam_policy_doc)
}
