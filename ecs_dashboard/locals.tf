locals {
  metric_list = [
    {
      aggregation = "Average"
      metric      = "cpu_usage_iowait"
      title       = "CPU I/O time"
    },
    {
      aggregation = "Average"
      metric      = "cpu_usage_user"
      title       = "CPU user time"
    },
    {
      aggregation = "Average"
      metric      = "cpu_usage_system"
      title       = "CPU system time"
    },
    {
      aggregation = "Average"
      metric      = "mem_used_percent"
      title       = "Memory used %"
    },
    {
      aggregation = "Average"
      metric      = "swap_used_percent"
      title       = "Swap used %"
    },
    {
      aggregation = "Average"
      metric      = "disk_used_percent"
      title       = "Disk used %"
    },
    {
      aggregation = "Average"
      metric      = "diskio_iops_in_progress"
      title       = "Disk ops pending"
    },
    {
      aggregation = "Sum"
      metric      = "diskio_read_time"
      title       = "Disk read wait time"
    },
    {
      aggregation = "Sum"
      metric      = "diskio_write_time"
      title       = "Disk write wait time"
    },
    {
      aggregation = "Sum"
      metric      = "net_bytes_recv"
      title       = "Net bytes received"
    },
    {
      aggregation = "Sum"
      metric      = "net_bytes_sent"
      title       = "Net bytes sent"
    },
    {
      aggregation = "Average"
      metric      = "netstat_tcp_time_wait"
      title       = "TCP connections closing"
    },
    {
      aggregation = "Average"
      metric      = "nvidia_gpu_utilization_gpu"
      title       = "GPU utilization %"
    },
    {
      aggregation = "Average"
      metric      = "nvidia_gpu_utilization_memory"
      title       = "GPU mem utilization %"
    },
    {
      aggregation = "Average"
      metric      = "nvidia_gpu_memory_used"
      title       = "GPU mem used MB"
    },
    {
      aggregation = "Average"
      metric      = "nvidia_gpu_memory_free"
      title       = "GPU mem free MB"
    },
  ]
  dashboard_body = {
    widgets = [
      for v_metric in local.metric_list : {
        height = local.widget_height
        properties = {
          metrics = [
            [
              {
                expression = "SEARCH('Namespace=\"CWAgent\" ${v_metric.metric}', '${v_metric.aggregation}', 60)"
              }
            ]
          ],
          period = 60
          region = var.std_map.aws_region_name
          title  = v_metric.title
        }
        type  = "metric",
        width = local.widget_width
        yAxis = local.y_axis_object
      }
    ]
  }
  widget_height = 8
  widget_width  = 12
  y_axis_object = {
    left = {
      showUnits = false
    }
    right = {
      showUnits = false
    }
  }
}
