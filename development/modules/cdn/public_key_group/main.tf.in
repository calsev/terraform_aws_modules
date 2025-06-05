resource "aws_cloudfront_key_group" "this_group" {
  for_each = local.lx_map
  items    = each.value.key_id_list
  name     = each.value.name_effective
}
