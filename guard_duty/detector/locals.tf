module "name_map" {
  source                          = "../../name_map"
  name_append_default             = var.name_append_default
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_map                        = local.l0_map
  name_prepend_default            = var.name_prepend_default
  std_map                         = var.std_map
}

locals {
  l0_map = {
    for k, v in var.detector_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      detect_ec2_ebs_malware_enabled      = v.detect_ec2_ebs_malware_enabled == null ? var.detector_detect_ec2_ebs_malware_enabled_default : v.detect_ec2_ebs_malware_enabled
      detect_kubernetes_audit_log_enabled = v.detect_kubernetes_audit_log_enabled == null ? var.detector_detect_kubernetes_audit_log_enabled_default : v.detect_kubernetes_audit_log_enabled
      detect_s3_log_enabled               = v.detect_s3_log_enabled == null ? var.detector_detect_s3_log_enabled_default : v.detect_s3_log_enabled
      finding_publishing_frequency        = v.finding_publishing_frequency == null ? var.detector_finding_publishing_frequency_default : v.finding_publishing_frequency
      is_enabled                          = v.is_enabled == null ? var.detector_is_enabled_default : v.is_enabled
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
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
      }
    )
  }
}
