{{ name.map() }}

module "vpc_map" {
  source                  = "../../vpc/id_map"
  vpc_map                 = local.l0_map
  vpc_az_key_list_default = var.vpc_az_key_list_default
  vpc_key_default         = var.vpc_key_default
  vpc_segment_key_default = var.vpc_segment_key_default
  vpc_data_map            = var.vpc_data_map
}

locals {
  create_password_map = {
    for k, v in local.lx_map : k => merge(v, {
      name_append = v.password_secret_name_append
    })
  }
  l0_map = {
    for k, v in var.directory_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], module.vpc_map.data[k], {
      active_directory_connect_customer_dns_ip_list = v.active_directory_connect_customer_dns_ip_list == null ? var.directory_active_directory_connect_customer_dns_ip_list_default : v.active_directory_connect_customer_dns_ip_list
      active_directory_connect_customer_username    = v.active_directory_connect_customer_username == null ? var.directory_active_directory_connect_customer_username_default : v.active_directory_connect_customer_username
      active_directory_edition                      = v.active_directory_edition == null ? var.directory_active_directory_edition_default : v.active_directory_edition
      alias                                         = v.alias == null ? var.directory_alias_default : v.alias
      directory_type                                = v.directory_type == null ? var.directory_type_default : v.directory_type
      instance_size                                 = v.instance_size == null ? var.directory_instance_size_default : v.instance_size
      password_secret_is_param                      = v.password_secret_is_param == null ? var.directory_password_secret_is_param_default : v.password_secret_is_param
      password_secret_name_append                   = v.password_secret_name_append == null ? var.password_secret_name_append_default : v.password_secret_name_append
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      domain_controller_count     = local.l1_map[k].directory_type == "MicrosoftAD" ? v.domain_controller_count == null ? var.directory_domain_controller_count_default : v.domain_controller_count : null
      is_active_directory_connect = local.l1_map[k].directory_type == "ADConnector"
      sso_enabled                 = v.sso_enabled == null ? var.directory_sso_enabled_default == null ? local.l1_map[k].alias != null : var.directory_sso_enabled_default : v.sso_enabled
      supports_vpc                = contains(["MicrosoftAD", "SimpleAD"], local.l1_map[k].directory_type)
    }
  }
  lx_map = {
    for k, _ in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k])
  }
  output_data = {
    for k, v in local.lx_map : k => merge(
      {
        for k_attr, v_attr in v : k_attr => v_attr if !contains([], k_attr)
      },
      {
        directory_access_url = aws_directory_service_directory.this_dir[k].access_url
        directory_id         = aws_directory_service_directory.this_dir[k].id
        password             = module.password_secret.data[k]
      }
    )
  }
}
