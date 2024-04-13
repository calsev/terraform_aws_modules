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
  secret_random_init_key_default         = "license_key"
  std_map                                = var.std_map
}

module "password_secret" {
  source                                 = "../../secret/random"
  secret_is_param_default                = var.instance_secret_is_param_default
  secret_map                             = local.create_open_vpn_password_map
  secret_name_include_app_fields_default = var.instance_name_include_app_fields_default
  secret_name_infix_default              = var.instance_name_infix_default
  secret_random_init_key_default         = "password"
  secret_random_init_map_default = {
    username = "openvpn"
  }
  std_map = var.std_map
}

module "instance_role" {
  source                  = "../../iam/role/ec2/instance"
  for_each                = local.lx_map
  depends_on              = [module.dns_alias] # This is needed for certbot
  monitor_data            = var.monitor_data
  name_include_app_fields = each.value.name_include_app_fields
  name_infix              = each.value.name_infix
  name                    = each.key
  role_policy_attach_arn_map_default = {
    eip_associate    = var.iam_data.iam_policy_arn_ec2_associate_eip
    attribute_modify = var.iam_data.iam_policy_arn_ec2_modify_attribute
  }
  std_map = var.std_map
}

module "instance_template" {
  source                           = "../../ec2/instance_template"
  iam_data                         = var.iam_data
  image_search_ecs_gpu_tag_name    = var.image_search_ecs_gpu_tag_name
  image_search_tag_owner           = var.image_search_tag_owner
  compute_image_search_tag_default = "open_vpn"
  compute_instance_type_default    = var.instance_type_default
  compute_key_pair_key_default     = var.instance_key_pair_key_default
  compute_map = {
    for k, v in local.create_template_map : k => merge(v, {
      user_data_command_list = [
        "EC2_INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)",
        "aws ec2 associate-address --allow-reassociation --instance-id $EC2_INSTANCE_ID --allocation-id ${module.elastic_ip.data[k].eip_allocation_id}",
        "aws ec2 modify-instance-attribute --region ${var.std_map.aws_region_name} --no-source-dest-check --instance-id $EC2_INSTANCE_ID",
        "hostnamectl set-hostname '${v.dns_from_fqdn}'",
        "cd /usr/local/openvpn_as/scripts",
        "./sacli --user openvpn --new_pass=${module.password_secret.secret_map[v.k_password_secret]} SetLocalPassword",
        "snap install --classic certbot",
        "ln -s /snap/bin/certbot /usr/bin/certbot",
        "certbot certonly --standalone -n --preferred-challenges http --agree-tos -m ${v.cert_contact_email} -d ${v.dns_from_fqdn}",
        "sacli --key 'cs.priv_key' --value_file '/etc/letsencrypt/live/${v.dns_from_fqdn}/privkey.pem' ConfigPut",
        "sacli --key 'cs.cert' --value_file '/etc/letsencrypt/live/${v.dns_from_fqdn}/fullchain.pem' ConfigPut",
        "sacli start",
        "./liman Activate '${module.license_secret.secret_map[v.k_license_secret]}'",
      ]
    })
  }
  compute_name_include_app_fields_default       = var.instance_name_include_app_fields_default
  compute_name_infix_default                    = var.instance_name_infix_default
  compute_user_data_suppress_generation_default = var.instance_user_data_suppress_generation_default
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
