module "password_secret" {
  source                          = "../../secret/random"
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  secret_is_param_default         = var.directory_password_secret_is_param_default
  secret_map                      = local.create_password_map
  secret_random_init_key_default  = "password"
  std_map                         = var.std_map
}

resource "aws_directory_service_directory" "this_dir" {
  for_each                             = local.lx_map
  alias                                = each.value.alias
  desired_number_of_domain_controllers = each.value.domain_controller_count
  edition                              = each.value.active_directory_edition
  enable_sso                           = each.value.sso_enabled
  name                                 = each.value.name_simple # This is the FQDN
  dynamic "connect_settings" {
    for_each = each.value.is_active_directory_connect ? { this = {} } : {}
    content {
      customer_username = each.value.active_directory_connect_customer_username
      customer_dns_ips  = each.value.active_directory_connect_customer_dns_ip_list
      subnet_ids        = each.value.vpc_subnet_id_list
      vpc_id            = each.value.vpc_id
    }
  }
  lifecycle {
    ignore_changes = [
      password,
    ]
  }
  password   = jsondecode(module.password_secret.secret_map[each.key])["password"]
  short_name = each.value.short_name
  size       = each.value.instance_size
  tags       = each.value.tags
  type       = each.value.directory_type
  dynamic "vpc_settings" {
    for_each = each.value.supports_vpc ? { this = {} } : {}
    content {
      subnet_ids = each.value.vpc_subnet_id_list
      vpc_id     = each.value.vpc_id
    }
  }
}
