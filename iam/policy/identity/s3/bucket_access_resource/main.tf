module "this_policy" {
  source      = "../../../../../iam/policy/identity/access_resource"
  access_list = var.access_list
  name        = var.name
  name_infix  = var.name_infix
  name_prefix = var.name_prefix
  resource_map = {
    bucket = local.bucket_arn_list
    object = local.object_arn_list
    star   = ["*"]
  }
  service_name = "s3"
  std_map      = var.std_map
}
