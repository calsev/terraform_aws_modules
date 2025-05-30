resource "random_password" "this_secret" {
  for_each         = local.lx_map
  keepers          = each.value.random_keeper_map
  length           = each.value.random_length
  min_lower        = each.value.random_min_lower
  min_numeric      = each.value.random_min_numeric
  min_special      = each.value.random_min_special
  min_upper        = each.value.random_min_upper
  numeric          = each.value.random_min_numeric != 0
  override_special = each.value.random_special_character_set
  special          = each.value.random_min_special != 0
}
