output "data" {
  value = {
    availability_zone_name_list = local.availability_zone_name_list
    route_table_id_map          = local.route_table_id_map
    subnet_id_map               = local.subnet_id_map
    subnet_map                  = local.subnet_map
    vpc_cidr_block              = aws_vpc.this_vpc.cidr_block
    vpc_id                      = aws_vpc.this_vpc.id
    vpc_name                    = var.vpc_name
  }
}
