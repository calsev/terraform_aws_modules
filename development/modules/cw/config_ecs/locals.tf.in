locals {
  cw_config_cpu = {
    agent = {
      metrics_collection_interval = 60
      run_as_user                 = "root"
    }
    metrics = {
      append_dimensions = {
        AutoScalingGroupName = "$${aws:AutoScalingGroupName}"
        InstanceId           = "$${aws:InstanceId}"
      }
      metrics_collected = {
        collectd = {
          metrics_aggregation_interval = 60
        }
        cpu = {
          measurement = [
            # "cpu_usage_idle",
            "cpu_usage_iowait",
            "cpu_usage_system",
            "cpu_usage_user",
          ]
          metrics_collection_interval = 60
          resources = [
            "cpu-total",
          ]
          totalcpu = true
        }
        disk = {
          ignore_file_system_types = [
            "autofs",
            "cgroup",
            "cgroup2",
            "devtmpfs",
            "overlay",
            "proc",
            "squashfs",
            "sysfs",
            "tracefs",
            "tmpfs",
          ]
          measurement = [
            # "inodes_free",
            "used_percent",
          ]
          metrics_collection_interval = 60
          resources = [
            "/",
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
            "nvme0n1",
            "nvme1n1",
            "xvda",
            "xvdb",
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
          resources = [
            "eth0",
          ]
        }
        netstat = {
          measurement = [
            "tcp_established",
            "tcp_time_wait",
          ]
          metrics_collection_interval = 60
        }
        # statsd = {
        #   metrics_aggregation_interval = 60
        #   metrics_collection_interval  = 60
        #   service_address              = ":8125"
        # }
        swap = {
          measurement = [
            "swap_used_percent",
          ]
          metrics_collection_interval = 60
        }
      }
    }
  }
  cw_config_gpu = {
    agent = local.cw_config_cpu.agent
    metrics = {
      append_dimensions = local.cw_config_cpu.metrics.append_dimensions
      metrics_collected = merge(local.cw_config_cpu.metrics.metrics_collected, {
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
    }
  }
  output_data = {
    cw_config = {
      cpu = local.cw_config_cpu
      gpu = local.cw_config_gpu
    }
    ecs_ssm_param_map = {
      cpu = module.ssm_param_cw_config.data["cloudwatch_agent_config_ecs_cpu"]
      gpu = module.ssm_param_cw_config.data["cloudwatch_agent_config_ecs_gpu"]
    }
  }
}
