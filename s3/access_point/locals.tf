module "name_map" {
  source                          = "../../name_map"
  name_append_default             = var.name_append_default
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_map                        = local.l0_map
  name_prefix_default             = var.name_prefix_default
  name_prepend_default            = var.name_prepend_default
  name_regex_allow_list           = var.name_regex_allow_list
  name_suffix_default             = var.name_suffix_default
  std_map                         = var.std_map
}

module "vpc_map" {
  source          = "../../vpc/id_map"
  vpc_data_map    = var.vpc_data_map
  vpc_key_default = var.vpc_key_default
  vpc_map         = local.l0_map
}

locals {
  create_policy_map = {
    for k, v in local.lx_map : k => v if v.policy_create
  }
  l0_map = {
    for k, v in var.ap_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], module.vpc_map.data[k], {
      allow_public  = v.allow_public == null ? var.ap_allow_public_default : v.allow_public
      bucket_key    = v.bucket_key == null ? k : v.bucket_key
      policy_create = v.policy_create == null ? var.ap_policy_create_default : v.policy_create
      sid_map_l1    = v.sid_map == null ? {} : v.sid_map
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      bucket_name_effective = var.s3_data_map[local.l1_map[k].bucket_key].name_effective
      sid_map = {
        for k_sid, v_sid in local.l1_map[k].sid_map_l1 : k_sid => {
          access          = v_sid.access
          condition_map   = v_sid.condition_map == null ? var.ap_sid_condition_map_default : v_sid.condition_map
          identifier_list = v_sid.identifier_list == null ? var.ap_sid_identifier_list_default : v_sid.identifier_list
          identifier_type = v_sid.identifier_type == null ? var.ap_sid_identifier_type_default : v_sid.identifier_type
          object_key_list = v_sid.object_key_list == null ? var.ap_sid_object_key_list_default : v_sid.object_key_list
        }
      }
    }
  }
  lx_map = {
    for k, _ in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k])
  }
  output_data = {
    for k, v in local.lx_map : k => merge(
      {
        for k_attr, v_attr in v : k_attr => v_attr if !contains(["sid_map", "sid_map_l1"], k_attr)
      },
      {
        ap_arn         = aws_s3_access_point.this_ap[k].arn
        iam_policy_doc = v.policy_create ? module.this_bucket_policy[k].iam_policy_doc : null
      },
    )
  }
}
