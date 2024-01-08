locals {
  action_list = [
    "sts:AssumeRole",
  ]
  sid_map = {
    for k_sid, v_sid in var.sid_map : k_sid => {
      condition_map   = v_sid.condition_map == null ? {} : v_sid.condition_map
      identifier_list = v_sid.identifier_list == null ? var.sid_identifier_list_default : v_sid.identifier_list
      identifier_type = v_sid.identifier_type == null ? var.sid_identifier_type_default : v_sid.identifier_type
    }
  }
}
