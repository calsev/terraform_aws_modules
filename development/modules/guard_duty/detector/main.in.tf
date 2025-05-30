resource "aws_guardduty_detector" "this_detector" {
  for_each = local.lx_map
  # datasources # obsolete
  enable                       = each.value.is_enabled
  finding_publishing_frequency = each.value.finding_publishing_frequency
  tags                         = each.value.tags
}


resource "aws_guardduty_detector_feature" "this_feature" {
  for_each = local.create_feature_x_map
  dynamic "additional_configuration" {
    for_each = each.value.add_on_list
    content {
      name   = additional_configuration.value.name
      status = additional_configuration.value.enabled ? "ENABLED" : "DISABLED"
    }
  }
  detector_id = each.value.detector_id
  name        = each.value.k_feat
  status      = each.value.enabled ? "ENABLED" : "DISABLED"
}
