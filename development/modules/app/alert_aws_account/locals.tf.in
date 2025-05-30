locals {
  alert_subscription_1_list = flatten([
    for k_topic, v_topic in local.alert_topic_x_map : [
      for k_email in v_topic.email_address_list : merge(v_topic, {
        k_email = k_email
        k_topic = k_topic
      })
    ]
  ])
  alert_subscription_x_map = {
    for v in local.alert_subscription_1_list : v.k_email => v.k_topic...
  }
  alert_topic_x_map = {
    for k, v in var.alert_level_map : k => merge(v, {
      email_address_list = v.email_address_list == null ? var.alert_email_address_list_default : v.email_address_list
    })
  }
  change_subscription_1_list = flatten([
    for k_topic, v_topic in local.change_topic_x_map : [
      for k_email in v_topic.email_address_list : merge(v_topic, {
        k_email = k_email
        k_topic = k_topic
      })
    ]
  ])
  change_subscription_x_map = {
    for v in local.change_subscription_1_list : v.k_email => v.k_topic...
  }
  change_topic_x_map = {
    for k, v in var.change_level_map : "change_${k}" => merge(v, {
      email_address_list = v.email_address_list == null ? var.change_email_address_list_default == null ? var.alert_email_address_list_default : var.change_email_address_list_default : v.email_address_list
    })
  }
  output_data = merge(
    module.alert_topic.data,
    {
      metric_alert = {
        alarm  = module.metric_alarm.data
        filter = module.metric_filter.data
        kms    = module.kms_key.data
        topic  = module.change_topic.data
        trail  = module.cloudtrail.data
      }
    },
  )
}
