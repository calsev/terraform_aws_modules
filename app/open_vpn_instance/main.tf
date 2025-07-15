module "elastic_ip" {
  source                          = "../../ec2/elastic_ip"
  ip_map                          = local.create_ip_map
  name_append_default             = var.name_append_default
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_prefix_default             = var.name_prefix_default
  name_prepend_default            = var.name_prepend_default
  name_suffix_default             = var.name_suffix_default
  std_map                         = var.std_map
}

module "dns_alias" {
  source                           = "../../dns/record"
  dns_data                         = var.dns_data
  record_dns_from_zone_key_default = var.instance_dns_from_zone_key_default
  record_map                       = local.create_dns_alias_map
  std_map                          = var.std_map
}

module "license_secret" {
  source                          = "../../secret/random"
  name_append_default             = "license"
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_prefix_default             = var.name_prefix_default
  name_prepend_default            = var.name_prepend_default
  name_suffix_default             = var.name_suffix_default
  secret_is_param_default         = var.instance_secret_is_param_default
  secret_map                      = local.lx_map
  secret_random_init_key_default  = "license_key"
  std_map                         = var.std_map
}

module "password_secret" {
  source                          = "../../secret/random"
  name_append_default             = "password"
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_prefix_default             = var.name_prefix_default
  name_prepend_default            = var.name_prepend_default
  name_suffix_default             = var.name_suffix_default
  secret_is_param_default         = var.instance_secret_is_param_default
  secret_map                      = local.lx_map
  secret_random_init_key_default  = "password"
  secret_random_init_map_default = {
    username = "openvpn"
  }
  std_map = var.std_map
}

module "instance_role" {
  source                          = "../../iam/role/ec2/instance"
  for_each                        = local.lx_map
  depends_on                      = [module.dns_alias] # This is needed for certbot
  map_policy                      = each.value
  monitor_data                    = var.monitor_data
  name                            = each.key
  name_append_default             = var.name_append_default
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_prefix_default             = var.name_prefix_default
  name_prepend_default            = var.name_prepend_default
  name_suffix_default             = var.name_suffix_default
  std_map                         = var.std_map
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
        "TOKEN=$(curl -X PUT 'http://169.254.169.254/latest/api/token' -H 'X-aws-ec2-metadata-token-ttl-seconds: 21600')",
        "EC2_INSTANCE_ID=$(curl -H \"X-aws-ec2-metadata-token: $TOKEN\" -s http://169.254.169.254/latest/meta-data/instance-id)",
        v.create_dns_alias ? "aws ec2 associate-address --allow-reassociation --instance-id $EC2_INSTANCE_ID --allocation-id ${module.elastic_ip.data[k].eip_allocation_id}" : "",
        "aws ec2 modify-instance-attribute --region ${var.std_map.aws_region_name} --no-source-dest-check --instance-id $EC2_INSTANCE_ID",
        "hostnamectl set-hostname '${v.dns_from_fqdn}'",
        v.create_dns_alias ? "snap install --classic certbot" : "",
        v.create_dns_alias ? "ln -s /snap/bin/certbot /usr/bin/certbot" : "",
        v.create_dns_alias ? "certbot certonly --standalone -n --preferred-challenges http --agree-tos -m ${v.cert_contact_email} -d ${v.dns_from_fqdn}" : "",
        v.create_dns_alias ? "sacli --key 'cs.priv_key' --value_file '/etc/letsencrypt/live/${v.dns_from_fqdn}/privkey.pem' ConfigPut" : "",
        v.create_dns_alias ? "sacli --key 'cs.cert' --value_file '/etc/letsencrypt/live/${v.dns_from_fqdn}/fullchain.pem' ConfigPut" : "",
        "cd /usr/local/openvpn_as/scripts",
        "sacli --user openvpn --new_pass='${v.secret_password}' SetLocalPassword",
        "sacli start",
        "./liman Activate '${module.license_secret.secret_map[k]}'",
      ]
    })
  }
  compute_user_data_suppress_generation_default = var.instance_user_data_suppress_generation_default
  monitor_data                                  = var.monitor_data
  name_append_default                           = var.name_append_default
  name_include_app_fields_default               = var.name_include_app_fields_default
  name_infix_default                            = var.name_infix_default
  name_prefix_default                           = var.name_prefix_default
  name_prepend_default                          = var.name_prepend_default
  name_suffix_default                           = var.name_suffix_default
  std_map                                       = var.std_map
  vpc_az_key_list_default                       = var.vpc_az_key_list_default
  vpc_data_map                                  = var.vpc_data_map
  vpc_key_default                               = var.vpc_key_default
}

module "target_group" {
  source                          = "../../elb/target_group"
  name_append_default             = var.name_append_default
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_prefix_default             = var.name_prefix_default
  name_prepend_default            = var.name_prepend_default
  name_suffix_default             = var.name_suffix_default
  std_map                         = var.std_map
  target_map                      = local.create_elb_target_x_map
  target_type_default             = "instance"
  vpc_data_map                    = var.vpc_data_map
  vpc_key_default                 = var.vpc_key_default
}

module "listener" {
  source              = "../../elb/listener"
  dns_data            = var.dns_data
  elb_data_map        = var.elb_data_map
  elb_target_data_map = module.target_group.data
  listener_action_map_default = {
    forward_to_service = {}
  }
  listener_action_type_default       = "forward"
  listener_dns_from_zone_key_default = var.instance_dns_from_zone_key_default
  listener_map                       = local.create_elb_listener_x_map
  name_append_default                = var.name_append_default
  name_include_app_fields_default    = var.name_include_app_fields_default
  name_infix_default                 = var.name_infix_default
  name_prefix_default                = var.name_prefix_default
  name_prepend_default               = var.name_prepend_default
  name_suffix_default                = var.name_suffix_default
  std_map                            = var.std_map
}

module "asg" {
  source                                                 = "../../ec2/auto_scaling_group"
  elb_target_data_map                                    = module.target_group.data
  group_auto_scaling_iam_role_arn_service_linked_default = null
  group_auto_scaling_num_instances_max_default           = 1
  group_auto_scaling_protect_from_scale_in_default       = var.group_auto_scaling_protect_from_scale_in_default
  group_map                                              = local.create_asg_map
  group_suspended_processes_default = [
    # The instance currently requires manual initialization
    "InstanceRefresh",
    "ReplaceUnhealthy",
  ]
  monitor_data                    = var.monitor_data
  name_append_default             = var.name_append_default
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_prefix_default             = var.name_prefix_default
  name_prepend_default            = var.name_prepend_default
  name_suffix_default             = var.name_suffix_default
  std_map                         = var.std_map
  vpc_az_key_list_default         = var.vpc_az_key_list_default
  vpc_data_map                    = var.vpc_data_map
  vpc_key_default                 = var.vpc_key_default
}
