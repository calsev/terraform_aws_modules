module "this_policy" {
  source      = "../iam_policy_identity_access_resource"
  access_list = var.access_list
  name        = var.name
  name_infix  = var.name_infix
  name_prefix = var.name_prefix
  resource_map = {
    distribution = [var.cdn_arn]
    star         = ["*"]
  }
  service_name = "cloudfront"
  std_map      = var.std_map
}
