locals {
  from_cidr_list = [
    var.vpc_data.vpc_cidr_block,
  ]
  from_ipv6_cidr_list = [
    var.vpc_data.vpc_ipv6_cidr_block,
  ]
  efs_read_actions = [
    "elasticfilesystem:ClientMount",
    "elasticfilesystem:DescribeMountTargets",
  ]
  efs_read_policy_name = "${var.std_map.resource_name_prefix}efs-read${var.std_map.resource_name_suffix}"
  efs_write_actions = [
    "elasticfilesystem:ClientRootAccess", # Needed to delete files owned by root
    "elasticfilesystem:ClientWrite",
  ]
  efs_write_policy_name = "${var.std_map.resource_name_prefix}efs-write${var.std_map.resource_name_suffix}"
  output_data = {
    efs_arn                  = aws_efs_file_system.this_fs.arn
    efs_dns_name             = aws_efs_file_system.this_fs.dns_name
    efs_id                   = aws_efs_file_system.this_fs.id
    iam_policy_arn_efs_read  = var.create_policies ? aws_iam_policy.iam_policy_efs_read["this"].arn : null
    iam_policy_arn_efs_write = var.create_policies ? aws_iam_policy.iam_policy_efs_write["this"].arn : null
    iam_policy_doc_efs_read  = jsondecode(data.aws_iam_policy_document.efs_read.json)
    iam_policy_doc_efs_write = jsondecode(data.aws_iam_policy_document.efs_write.json)
  }
  resource_name            = "${var.std_map.resource_name_prefix}${var.name}${var.std_map.resource_name_suffix}"
  security_group_id_egress = var.vpc_data.security_group_map[var.vpc_security_group_key_egress].id
  sg_name                  = "${var.std_map.resource_name_prefix}efs-mount${var.std_map.resource_name_suffix}"
  subnet_id_map            = var.vpc_data.segment_map[var.vpc_segment_key].subnet_id_map
  tags = merge(
    var.std_map.tags,
    {
      Name = local.resource_name
    }
  )
}
