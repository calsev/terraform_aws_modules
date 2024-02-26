module "elastic_ip" {
  source  = "../../ec2/elastic_ip"
  ip_map  = local.lx_map
  std_map = var.std_map
}

#resource "aws_route53_record" "calsev_com_acm_ecr" {
#  name    = "${local.dns_name}."
#  records = [aws_eip.vpn.public_dns]
#  type    = "CNAME"
#  zone_id = data.terraform_remote_state.dns.outputs.data.domain_to_dns_zone_map["calsev.com"].dns_zone_id
#}

module "instance_template" {
  source                                  = "../../ec2/instance_template"
  image_search_ecs_gpu_tag_name           = var.image_search_ecs_gpu_tag_name
  image_search_tag_owner                  = var.image_search_tag_owner
  compute_image_search_tag_default        = "open_vpn"
  compute_instance_type_default           = var.instance_type_default
  compute_key_name_default                = var.instance_key_name_default
  compute_map                             = local.lx_map
  compute_name_include_app_fields_default = var.instance_name_include_app_fields_default
  compute_name_infix_default              = var.instance_name_infix_default
  monitor_data                            = var.monitor_data
  std_map                                 = var.std_map
  vpc_az_key_list_default                 = var.vpc_az_key_list_default
  vpc_data_map                            = var.vpc_data_map
  vpc_key_default                         = var.vpc_key_default
  vpc_security_group_key_list_default     = var.vpc_security_group_key_list_default
  vpc_segment_key_default                 = var.vpc_segment_key_default
}

module "asg" {
  source                                                 = "../../ec2/auto_scaling_group"
  group_auto_scaling_iam_role_arn_service_linked_default = null
  group_auto_scaling_num_instances_max_default           = 1
  group_auto_scaling_num_instances_min_default           = var.instance_auto_scaling_num_instances_min_default
  group_auto_scaling_protect_from_scale_in_default       = var.instance_auto_scaling_protect_from_scale_in_default
  group_map                                              = local.create_asg_map
  group_name_include_app_fields_default                  = var.instance_name_include_app_fields_default
  group_name_infix_default                               = var.instance_name_infix_default
  std_map                                                = var.std_map
  vpc_az_key_list_default                                = var.vpc_az_key_list_default
  vpc_data_map                                           = var.vpc_data_map
  vpc_key_default                                        = var.vpc_key_default
  vpc_security_group_key_list_default                    = var.vpc_security_group_key_list_default
  vpc_segment_key_default                                = var.vpc_segment_key_default
}
