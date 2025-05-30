resource "aws_codedeploy_app" "this_app" {
  for_each         = local.lx_map
  compute_platform = each.value.compute_platform
  name             = each.value.name_effective
  tags             = each.value.tags
}
