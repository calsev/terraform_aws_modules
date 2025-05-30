resource "aws_inspector2_enabler" "this_enabler" {
  for_each       = local.lx_map
  account_ids    = each.value.aws_account_id_list
  resource_types = each.value.resource_type_list
}
