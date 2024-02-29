module "elastic_ip" {
  source                             = "../../ec2/elastic_ip"
  ip_map                             = local.lx_map
  ip_name_include_app_fields_default = var.instance_name_include_app_fields_default
  ip_name_infix_default              = var.instance_name_infix_default
  std_map                            = var.std_map
}

module "dns_alias" {
  source                           = "../../dns/record"
  dns_data                         = var.dns_data
  record_dns_from_zone_key_default = var.instance_dns_from_zone_key_default
  record_map                       = local.create_dns_alias_map
  std_map                          = var.std_map
}

module "license_secret" {
  source                                 = "../../secret/random"
  secret_is_param_default                = var.instance_secret_is_param_default
  secret_map                             = local.create_open_vpn_license_map
  secret_name_include_app_fields_default = var.instance_name_include_app_fields_default
  secret_name_infix_default              = var.instance_name_infix_default
  std_map                                = var.std_map
}

module "password_secret" {
  source                                 = "../../secret/random"
  secret_is_param_default                = var.instance_secret_is_param_default
  secret_map                             = local.create_open_vpn_password_map
  secret_name_include_app_fields_default = var.instance_name_include_app_fields_default
  secret_name_infix_default              = var.instance_name_infix_default
  std_map                                = var.std_map
}

module "instance_role" {
  source                   = "../../iam/role/base"
  for_each                 = local.lx_map
  assume_role_service_list = ["ec2"]
  create_instance_profile  = true
  name_include_app_fields  = each.value.name_include_app_fields
  name_infix               = each.value.name_infix
  name                     = each.key
  role_policy_attach_arn_map_default = {
    eip_associate    = var.iam_data.iam_policy_arn_ec2_associate_eip
    attribute_modify = var.iam_data.iam_policy_arn_ec2_modify_attribute
  }
  std_map = var.std_map
}

module "instance_template" {
  source                           = "../../ec2/instance_template"
  image_search_ecs_gpu_tag_name    = var.image_search_ecs_gpu_tag_name
  image_search_tag_owner           = var.image_search_tag_owner
  compute_image_search_tag_default = "open_vpn"
  compute_instance_type_default    = var.instance_type_default
  compute_key_name_default         = var.instance_key_name_default
  compute_map = {
    for k, v in local.create_template_map : k => merge(v, {
      user_data_commands = [
        "license=${module.license_secret.secret_map[v.k_license_secret]}",
        "admin_pw=${module.password_secret.secret_map[v.k_password_secret]}",
        # Install AWS CLI?
        "EC2_INSTANCE_ID=$(wget -q -O - http://169.254.169.254/latest/meta-data/instance-id)",
        "EC2_INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)",
        "aws ec2 modify-instance-attribute --region ${var.std_map.aws_region_name} --no-source-dest-check --instance-id $EC2_INSTANCE_ID",
        "aws ec2 associate-address --allow-reassociation --instance-id $EC2_INSTANCE_ID --allocation-id ${module.elastic_ip.data[k].eip_allocation_id}",
      ]
    })
  }
  compute_name_include_app_fields_default       = var.instance_name_include_app_fields_default
  compute_name_infix_default                    = var.instance_name_infix_default
  compute_user_data_suppress_generation_default = true
  monitor_data                                  = var.monitor_data
  std_map                                       = var.std_map
  vpc_az_key_list_default                       = var.vpc_az_key_list_default
  vpc_data_map                                  = var.vpc_data_map
  vpc_key_default                               = var.vpc_key_default
  vpc_security_group_key_list_default           = var.vpc_security_group_key_list_default
  vpc_segment_key_default                       = var.vpc_segment_key_default
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
