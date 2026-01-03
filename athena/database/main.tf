resource "aws_athena_database" "this_db" {
  for_each = local.lx_map
  acl_configuration {
    s3_acl_option = "BUCKET_OWNER_FULL_CONTROL"
  }
  bucket = each.value.bucket_name
  encryption_configuration {
    encryption_option = each.value.encryption_option
    kms_key           = each.value.kms_key_id
  }
  expected_bucket_owner = var.std_map.aws_account_id
  force_destroy         = each.value.force_destroy
  name                  = replace(each.value.name_effective, "-", "_") # No dash allowed
  properties            = each.value.property_map
  region                = var.std_map.aws_region_name
  workgroup             = each.value.workgroup
}
