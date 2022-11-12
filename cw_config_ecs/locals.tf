locals {
  cw_config_cpu = {
    agent = {
      metrics_collection_interval = 60
      run_as_user                 = "root"
    }
    metrics = {
      append_dimensions = {
        AutoScalingGroupName = "$${aws:AutoScalingGroupName}"
        ImageId              = "$${aws:ImageId}"
        InstanceId           = "$${aws:InstanceId}"
        InstanceType         = "$${aws:InstanceType}"
      }
      metrics_collected = {
        collectd = {
          metrics_aggregation_interval = 60
        }
        cpu = {
          measurement = [
            "cpu_usage_idle",
            "cpu_usage_iowait",
            "cpu_usage_system",
            "cpu_usage_user",
          ]
          metrics_collection_interval = 60
          resources = [
            "*"
          ]
          totalcpu = true
        }
        disk = {
          measurement = [
            "inodes_free",
            "used_percent",
          ]
          metrics_collection_interval = 60
          resources = [
            "*",
          ]
        }
        diskio = {
          measurement = [
            "iops_in_progress",
            "io_time",
            "read_bytes",
            "read_time",
            "reads",
            "write_bytes",
            "write_time",
            "writes",
          ]
          metrics_collection_interval = 60
          resources = [
            "*",
          ]
        }
        mem = {
          measurement = [
            "mem_used_percent"
          ]
          metrics_collection_interval = 60
        }
        net = {
          measurement = [
            "bytes_recv",
            "bytes_sent",
          ]
          metrics_collection_interval = 60
        }
        netstat = {
          measurement = [
            "tcp_established",
            "tcp_time_wait",
          ]
          metrics_collection_interval = 60
        }
        statsd = {
          metrics_aggregation_interval = 60
          metrics_collection_interval  = 10
          service_address              = ":8125"
        }
        swap = {
          measurement = [
            "swap_used_percent",
          ]
          metrics_collection_interval = 60
        }
      }
    }
  }
  cw_config_gpu = merge(local.cw_config_cpu, {
    nvidia_gpu = {
      measurement = [
        "memory_free",
        "memory_used",
        "utilization_gpu",
        "utilization_memory",
      ]
      metrics_collection_interval = 60
    }
  })
  cw_config_name_cpu = "${var.std_map.resource_name_prefix}cloudwatch-agent-config-ecs-cpu${var.std_map.resource_name_suffix}" # This must match the read policy in IAM
  cw_config_name_gpu = "${var.std_map.resource_name_prefix}cloudwatch-agent-config-ecs-gpu${var.std_map.resource_name_suffix}" # This must match the read policy in IAM
  output_data = {
    ssm_param_name = {
      cpu = aws_ssm_parameter.ssm_param_cw_config_cpu.name
      gpu = aws_ssm_parameter.ssm_param_cw_config_gpu.name
    }
  }
}
