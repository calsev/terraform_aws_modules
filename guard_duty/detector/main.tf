resource "aws_guardduty_detector" "this_detector" {
  for_each = local.lx_map
  datasources {
    kubernetes {
      audit_logs {
        enable = each.value.detect_kubernetes_audit_log_enabled
      }
    }
    malware_protection {
      scan_ec2_instance_with_findings {
        ebs_volumes {
          enable = each.value.detect_ec2_ebs_malware_enabled
        }
      }
    }
    s3_logs {
      enable = each.value.detect_s3_log_enabled
    }
  }
  enable                       = each.value.is_enabled
  finding_publishing_frequency = each.value.finding_publishing_frequency
  tags                         = each.value.tags
}
