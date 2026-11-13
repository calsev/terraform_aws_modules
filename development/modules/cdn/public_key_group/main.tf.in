resource "aws_cloudfront_key_group" "this_group" {
  for_each = local.lx_map
  items    = each.value.key_id_list
  lifecycle {
    # Membership is set at creation only; key rotation (such as a Secrets Manager rotation function) owns it afterwards
    ignore_changes = [
      items,
    ]
  }
  name = each.value.name_effective
}
