resource "aws_iam_service_linked_role" "this_role" {
  for_each         = local.lx_map
  aws_service_name = "${each.key}.amazonaws.com"
}
