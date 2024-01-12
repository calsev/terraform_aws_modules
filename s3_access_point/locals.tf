module "name_map" {
  source             = "../name_map"
  name_infix_default = var.ap_name_infix_default
  name_map           = var.ap_map
  std_map            = var.std_map
}

module "vpc_map" {
  source          = "../vpc/id_map"
  vpc_key_default = var.vpc_key_default
  vpc_map         = var.ap_map
  vpc_data_map    = var.vpc_data_map
}

locals {
  ap_map = {
    for k, v in var.ap_map : k => merge(local.l1_map[k], local.l2_map[k])
  }
  ap_policy_map = {
    for k, v in local.ap_map : k => v if v.policy_create
  }
  l1_map = {
    for k, v in var.ap_map : k => merge(v, module.name_map.data[k], module.vpc_map.data[k], {
      allow_public  = v.allow_public == null ? var.ap_allow_public_default : v.allow_public
      policy_create = v.policy_create == null ? var.ap_policy_create_default : v.policy_create
      sid_map_l1    = v.sid_map == null ? {} : v.sid_map
    })
  }
  l2_map = {
    for k, _ in var.ap_map : k => {
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
  output_data = {
    for k, v in local.ap_map : k => merge(
      {
        for k_bucket, v_bucket in v : k_bucket => v_bucket if !contains(["sid_map", "sid_map_l1"], k_bucket)
      },
      {
        arn            = aws_s3_access_point.this_ap[k].arn
        iam_policy_doc = v.policy_create ? module.this_bucket_policy[k].iam_policy_doc : null
      },
    )
  }
}
