module "vpc_map" {
  source                  = "../vpc_id_map"
  vpc_map                 = var.group_map
  vpc_az_key_list_default = var.vpc_az_key_list_default
  vpc_key_default         = var.vpc_key_default
  vpc_segment_key_default = var.vpc_segment_key_default
  vpc_data_map            = var.vpc_data_map
}

resource "aws_db_subnet_group" "this_subnet_group" {
  for_each    = local.group_map
  name        = each.value.name_is_prefix ? null : each.value.name_effective
  name_prefix = each.value.name_is_prefix ? each.value.name_effective : null
  subnet_ids  = each.value.vpc_subnet_id_list
  tags        = each.value.tags
}
