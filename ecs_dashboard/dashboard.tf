resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${var.std_map.resource_name_prefix}metrics${var.std_map.resource_name_suffix}"
  dashboard_body = jsonencode({
    widgets = [
      {
        width  = local.widget_width
        height = local.widget_height

        properties = {
          metrics = [
            [

              {
                expression = "SEARCH('Namespace=\"CWAgent\" cpu_usage_iowait', 'Average', 60)"
              }
            ]
          ],
          period = 60
          region = var.std_map.aws_region_name
          title  = "CPU I/O time"
        }
        type  = "metric",
        yAxis = local.y_axis_object
      },
      {
        width  = local.widget_width
        height = local.widget_height

        properties = {
          metrics = [
            [

              {
                expression = "SEARCH('Namespace=\"CWAgent\" cpu_usage_user', 'Average', 60)"
              }
            ]
          ],
          period = 60
          region = var.std_map.aws_region_name
          title  = "CPU user time"
        }
        type  = "metric",
        yAxis = local.y_axis_object
      },
      {
        width  = local.widget_width
        height = local.widget_height

        properties = {
          metrics = [
            [

              {
                expression = "SEARCH('Namespace=\"CWAgent\" cpu_usage_system', 'Average', 60)"
              }
            ]
          ],
          period = 60
          region = var.std_map.aws_region_name
          title  = "CPU system time"
        }
        type  = "metric",
        yAxis = local.y_axis_object
      },
      {
        width  = local.widget_width
        height = local.widget_height

        properties = {
          metrics = [
            [

              {
                expression = "SEARCH('Namespace=\"CWAgent\" mem_used_percent', 'Average', 60)"
              }
            ]
          ],
          period = 60
          region = var.std_map.aws_region_name
          title  = "Memory used %"
        }
        type  = "metric",
        yAxis = local.y_axis_object
      },
      {
        width  = local.widget_width
        height = local.widget_height

        properties = {
          metrics = [
            [

              {
                expression = "SEARCH('Namespace=\"CWAgent\" swap_used_percent', 'Average', 60)"
              }
            ]
          ],
          period = 60
          region = var.std_map.aws_region_name
          title  = "Swap used %"
        }
        type  = "metric",
        yAxis = local.y_axis_object
      },
      {
        width  = local.widget_width
        height = local.widget_height

        properties = {
          metrics = [
            [

              {
                expression = "SEARCH('Namespace=\"CWAgent\" disk_used_percent', 'Average', 60)"
              }
            ]
          ],
          period = 60
          region = var.std_map.aws_region_name
          title  = "Disk used %"
        }
        type  = "metric",
        yAxis = local.y_axis_object
      },
      {
        width  = local.widget_width
        height = local.widget_height

        properties = {
          metrics = [
            [

              {
                expression = "SEARCH('Namespace=\"CWAgent\" diskio_iops_in_progress', 'Average', 60)"
              }
            ]
          ],
          period = 60
          region = var.std_map.aws_region_name
          title  = "Disk ops pending"
        }
        type  = "metric",
        yAxis = local.y_axis_object
      },
      {
        width  = local.widget_width
        height = local.widget_height

        properties = {
          metrics = [
            [

              {
                expression = "SEARCH('Namespace=\"CWAgent\" diskio_read_time', 'Sum', 60)"
              }
            ]
          ],
          period = 60
          region = var.std_map.aws_region_name
          title  = "Disk read wait time"
        }
        type  = "metric",
        yAxis = local.y_axis_object
      },
      {
        width  = local.widget_width
        height = local.widget_height

        properties = {
          metrics = [
            [

              {
                expression = "SEARCH('Namespace=\"CWAgent\" diskio_write_time', 'Sum', 60)"
              }
            ]
          ],
          period = 60
          region = var.std_map.aws_region_name
          title  = "Disk write wait time"
        }
        type  = "metric",
        yAxis = local.y_axis_object
      },
      {
        width  = local.widget_width
        height = local.widget_height

        properties = {
          metrics = [
            [

              {
                expression = "SEARCH('Namespace=\"CWAgent\" net_bytes_recv', 'Sum', 60)"
              }
            ]
          ],
          period = 60
          region = var.std_map.aws_region_name
          title  = "Net bytes received"
        }
        type  = "metric",
        yAxis = local.y_axis_object
      },
      {
        width  = local.widget_width
        height = local.widget_height

        properties = {
          metrics = [
            [

              {
                expression = "SEARCH('Namespace=\"CWAgent\" net_bytes_sent', 'Sum', 60)"
              }
            ]
          ],
          period = 60
          region = var.std_map.aws_region_name
          title  = "Net bytes sent"
        }
        type  = "metric",
        yAxis = local.y_axis_object
      },
      {
        width  = local.widget_width
        height = local.widget_height

        properties = {
          metrics = [
            [

              {
                expression = "SEARCH('Namespace=\"CWAgent\" netstat_tcp_time_wait', 'Average', 60)"
              }
            ]
          ],
          period = 60
          region = var.std_map.aws_region_name
          title  = "TCP connections closing"
        }
        type  = "metric",
        yAxis = local.y_axis_object
      },
      {
        width  = local.widget_width
        height = local.widget_height

        properties = {
          metrics = [
            [

              {
                expression = "SEARCH('Namespace=\"CWAgent\" nvidia_gpu_utilization_gpu', 'Average', 60)"
              }
            ]
          ],
          period = 60
          region = var.std_map.aws_region_name
          title  = "GPU utilization %"
        }
        type  = "metric",
        yAxis = local.y_axis_object
      },
      {
        width  = local.widget_width
        height = local.widget_height

        properties = {
          metrics = [
            [

              {
                expression = "SEARCH('Namespace=\"CWAgent\" nvidia_gpu_utilization_memory', 'Average', 60)"
              }
            ]
          ],
          period = 60
          region = var.std_map.aws_region_name
          title  = "Memory utilization %"
        }
        type  = "metric",
        yAxis = local.y_axis_object
      },
      {
        width  = local.widget_width
        height = local.widget_height

        properties = {
          metrics = [
            [

              {
                expression = "SEARCH('Namespace=\"CWAgent\" nvidia_gpu_memory_used', 'Average', 60)"
              }
            ]
          ],
          period = 60
          region = var.std_map.aws_region_name
          title  = "Memory used MB"
        }
        type  = "metric",
        yAxis = local.y_axis_object
      },
      {
        width  = local.widget_width
        height = local.widget_height

        properties = {
          metrics = [
            [

              {
                expression = "SEARCH('Namespace=\"CWAgent\" nvidia_gpu_memory_free', 'Average', 60)"
              }
            ]
          ],
          period = 60
          region = var.std_map.aws_region_name
          title  = "Memory free MB"
        }
        type  = "metric",
        yAxis = local.y_axis_object
      },
    ]
  })
}
