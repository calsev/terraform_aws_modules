output "availability_zone_name_list" {
  value = local.availability_zone_name_list
}

output "vpc_data" {
  value = {
    route_table_id_map    = local.route_table_id_map
    security_group_id_map = local.security_group_id_object
    subnet_id_map         = local.subnet_id_map
    subnet_map            = local.subnet_map
    vpc_cidr_block        = aws_vpc.this_vpc.cidr_block
    vpc_id                = aws_vpc.this_vpc.id
    vpc_name              = var.vpc_name
  }
}

output "vpc_name" {
  value = var.vpc_name
}
