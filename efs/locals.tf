locals {
  from_cidr_list = [
    data.aws_vpc.this_vpc.cidr_block,
  ]
  from_ipv6_cidr_list = [
    data.aws_vpc.this_vpc.ipv6_cidr_block,
  ]
  efs_read_policy_name = "${var.std_map.resource_name_prefix}efs-read${var.std_map.resource_name_suffix}"
  efs_read_actions = [
    "elasticfilesystem:ClientMount",
    "elasticfilesystem:DescribeMountTargets",
  ]
  efs_write_actions = [
    "elasticfilesystem:ClientRootAccess", # Needed to delete files owned by root
    "elasticfilesystem:ClientWrite",
  ]
  efs_write_policy_name = "${var.std_map.resource_name_prefix}efs-write${var.std_map.resource_name_suffix}"
  iam_role_id_efs_read_map = {
    for id in var.iam_role_id_efs_read_list : id => {}
  }
  iam_role_id_efs_write_map = {
    for id in var.iam_role_id_efs_write_list : id => {}
  }
  resource_name = "${var.std_map.resource_name_prefix}${var.name}${var.std_map.resource_name_suffix}"
  sg_name       = "${var.std_map.resource_name_prefix}efs-mount${var.std_map.resource_name_suffix}"
  tags = merge(
    var.std_map.tags,
    {
      Name = local.resource_name
    }
  )
  subnet_id_map = {
    for id in data.aws_subnets.this_subnet.ids : id => {}
  }
}
