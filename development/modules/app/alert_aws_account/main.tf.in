module "alert_topic" {
  source = "../../sns/topic"
  subscription_map = {
    for k, v in local.alert_subscription_x_map : k => {
      k_topic_list = v
    }
  }
  topic_map = local.alert_topic_x_map
  std_map   = var.std_map
}

module "change_topic" {
  source = "../../sns/topic"
  subscription_map = {
    for k, v in local.change_subscription_x_map : k => {
      k_topic_list = v
    }
  }
  topic_map = local.change_topic_x_map
  std_map   = var.std_map
}

module "kms_key" {
  source = "../../kms/key"
  key_map = var.encrypt_trail_with_kms ? {
    trail = {}
  } : {}
  std_map = var.std_map
}

module "cloudtrail" {
  source                       = "../../cloudtrail/trail"
  kms_data_map                 = module.kms_key.data
  s3_data_map                  = var.s3_data_map
  std_map                      = var.std_map
  trail_kms_key_key_default    = var.encrypt_trail_with_kms ? "trail" : null
  trail_log_bucket_key_default = var.trail_log_bucket_key
  trail_map = {
    management_event = {
      advanced_event_selector_map = {
        "Management event selector" = {
          management_category_selector = {
            equal_list = ["Management"]
            field      = "eventCategory"
          }
        }
      }
      log_retention_days = var.trail_log_management_retention_days
    }
    s3_event = {
      advanced_event_selector_map = {
        "S3 data event selector" = {
          data_category_selector = {
            equal_list = ["Data"]
            field      = "eventCategory"
          }
          object_resource_selector = {
            equal_list = ["AWS::S3::Object"]
            field      = "resources.type"
          }
        }
      }
      insight_type_list  = []
      log_retention_days = var.trail_log_s3_retention_days
    }
  }
}

module "metric_filter" {
  source = "../../cw/metric_filter"
  log_data_map = {
    management_event = module.cloudtrail.data["management_event"].log
  }
  metric_log_group_key_default = "management_event"
  metric_map = {
    cloudtrail_change = {
      # https://docs.aws.amazon.com/securityhub/latest/userguide/cloudwatch-controls.html#cloudwatch-5
      pattern             = "{($.eventName=CreateTrail) || ($.eventName=UpdateTrail) || ($.eventName=DeleteTrail) || ($.eventName=StartLogging) || ($.eventName=StopLogging)}"
      transformation_name = "CloudtrailChange"
    }
    cmk_deletion = {
      # https://docs.aws.amazon.com/securityhub/latest/userguide/cloudwatch-controls.html#cloudwatch-7
      pattern             = "{($.eventSource=kms.amazonaws.com) && (($.eventName=DisableKey) || ($.eventName=ScheduleKeyDeletion))}"
      transformation_name = "CmkDeletion"
    }
    config_change = {
      # https://docs.aws.amazon.com/securityhub/latest/userguide/cloudwatch-controls.html#cloudwatch-9
      pattern             = "{($.eventSource=config.amazonaws.com) && (($.eventName=StopConfigurationRecorder) || ($.eventName=DeleteDeliveryChannel) || ($.eventName=PutDeliveryChannel) || ($.eventName=PutConfigurationRecorder))}"
      transformation_name = "ConfigChange"
    }
    console_1fa_sign_in = {
      # https://docs.aws.amazon.com/securityhub/latest/userguide/cloudwatch-controls.html#cloudwatch-3
      pattern             = "{ ($.eventName = \"ConsoleLogin\") && ($.additionalEventData.MFAUsed != \"Yes\") && ($.userIdentity.type = \"IAMUser\") && ($.responseElements.ConsoleLogin = \"Success\") }"
      transformation_name = "Console1faSignIn"
    }
    console_authentication_failure = {
      # https://docs.aws.amazon.com/securityhub/latest/userguide/cloudwatch-controls.html#cloudwatch-6
      pattern             = "{($.eventName=ConsoleLogin) && ($.errorMessage=\"Failed authentication\")}"
      transformation_name = "ConsoleAuthFail"
    }
    iam_policy_change = {
      # https://docs.aws.amazon.com/securityhub/latest/userguide/cloudwatch-controls.html#cloudwatch-4
      pattern             = "{($.eventSource=iam.amazonaws.com) && (($.eventName=DeleteGroupPolicy) || ($.eventName=DeleteRolePolicy) || ($.eventName=DeleteUserPolicy) || ($.eventName=PutGroupPolicy) || ($.eventName=PutRolePolicy) || ($.eventName=PutUserPolicy) || ($.eventName=CreatePolicy) || ($.eventName=DeletePolicy) || ($.eventName=CreatePolicyVersion) || ($.eventName=DeletePolicyVersion) || ($.eventName=AttachRolePolicy) || ($.eventName=DetachRolePolicy) || ($.eventName=AttachUserPolicy) || ($.eventName=DetachUserPolicy) || ($.eventName=AttachGroupPolicy) || ($.eventName=DetachGroupPolicy))}"
      transformation_name = "IamPolicyChange"
    }
    root_account_usage = {
      # https://docs.aws.amazon.com/securityhub/latest/userguide/cloudwatch-controls.html#cloudwatch-1
      pattern             = "{$.userIdentity.type=\"Root\" && $.userIdentity.invokedBy NOT EXISTS && $.eventType !=\"AwsServiceEvent\"}"
      transformation_name = "RootAccountUsage"
    }
    s3_bucket_policy_change = {
      # https://docs.aws.amazon.com/securityhub/latest/userguide/cloudwatch-controls.html#cloudwatch-8
      pattern             = "{($.eventSource=s3.amazonaws.com) && (($.eventName=PutBucketAcl) || ($.eventName=PutBucketPolicy) || ($.eventName=PutBucketCors) || ($.eventName=PutBucketLifecycle) || ($.eventName=PutBucketReplication) || ($.eventName=DeleteBucketPolicy) || ($.eventName=DeleteBucketCors) || ($.eventName=DeleteBucketLifecycle) || ($.eventName=DeleteBucketReplication))}"
      transformation_name = "S3PolicyChange"
    }
    security_group_change = {
      # https://docs.aws.amazon.com/securityhub/latest/userguide/cloudwatch-controls.html#cloudwatch-10
      pattern             = "{($.eventName=AuthorizeSecurityGroupIngress) || ($.eventName=AuthorizeSecurityGroupEgress) || ($.eventName=RevokeSecurityGroupIngress) || ($.eventName=RevokeSecurityGroupEgress) || ($.eventName=CreateSecurityGroup) || ($.eventName=DeleteSecurityGroup)}"
      transformation_name = "SecurityGroupChange"
    }
    unauthorized_api_call = {
      # https://docs.aws.amazon.com/securityhub/latest/userguide/cloudwatch-controls.html#cloudwatch-2
      pattern             = "{($.errorCode=\"*UnauthorizedOperation\") || ($.errorCode=\"AccessDenied*\")}"
      transformation_name = "UnauthorizedApiCall"
    }
    vpc_gateway_change = {
      # https://docs.aws.amazon.com/securityhub/latest/userguide/cloudwatch-controls.html#cloudwatch-12
      pattern             = "{($.eventName=CreateCustomerGateway) || ($.eventName=DeleteCustomerGateway) || ($.eventName=AttachInternetGateway) || ($.eventName=CreateInternetGateway) || ($.eventName=DeleteInternetGateway) || ($.eventName=DetachInternetGateway)}"
      transformation_name = "VpcGatewayChange"
    }
    vpc_nacl_change = {
      # https://docs.aws.amazon.com/securityhub/latest/userguide/cloudwatch-controls.html#cloudwatch-11
      pattern             = "{($.eventName=CreateNetworkAcl) || ($.eventName=CreateNetworkAclEntry) || ($.eventName=DeleteNetworkAcl) || ($.eventName=DeleteNetworkAclEntry) || ($.eventName=ReplaceNetworkAclEntry) || ($.eventName=ReplaceNetworkAclAssociation)}"
      transformation_name = "VpcNaclChange"
    }
    vpc_route_table_change = {
      # https://docs.aws.amazon.com/securityhub/latest/userguide/cloudwatch-controls.html#cloudwatch-13
      pattern             = "{($.eventSource=ec2.amazonaws.com) && (($.eventName=CreateRoute) || ($.eventName=CreateRouteTable) || ($.eventName=ReplaceRoute) || ($.eventName=ReplaceRouteTableAssociation) || ($.eventName=DeleteRouteTable) || ($.eventName=DeleteRoute) || ($.eventName=DisassociateRouteTable))}"
      transformation_name = "VpcRouteTableChange"
    }
    vpc_vpc_change = {
      # https://docs.aws.amazon.com/securityhub/latest/userguide/cloudwatch-controls.html#cloudwatch-14
      pattern             = "{($.eventName=CreateVpc) || ($.eventName=DeleteVpc) || ($.eventName=ModifyVpcAttribute) || ($.eventName=AcceptVpcPeeringConnection) || ($.eventName=CreateVpcPeeringConnection) || ($.eventName=DeleteVpcPeeringConnection) || ($.eventName=RejectVpcPeeringConnection) || ($.eventName=AttachClassicLinkVpc) || ($.eventName=DetachClassicLinkVpc) || ($.eventName=DisableVpcClassicLink) || ($.eventName=EnableVpcClassicLink)}"
      transformation_name = "VpcChange"
    }
  }
  metric_transformation_namespace_default = "LogMetrics"
  std_map                                 = var.std_map
}

module "metric_alarm" {
  source = "../../cw/metric_alarm"
  alarm_map = {
    cloudtrail_change = {
      alarm_description = "A Cloudtrail trail changed."
      alarm_name        = "Cloudtrail change"
      metric_name       = "CloudtrailChange"
    }
    cmk_deletion = {
      alarm_description = "A customer-managed key was disabled or scheduled for deletion."
      alarm_name        = "CMK deletion"
      metric_name       = "CmkDeletion"
    }
    config_change = {
      alarm_description = "A Config configuration changed."
      alarm_name        = "Config configuration change"
      metric_name       = "ConfigChange"
    }
    console_1fa_sign_in = {
      alarm_description = "A successful sign-in to the console occured using only one factor for authentication."
      alarm_name        = "Console 1FA sign in"
      metric_name       = "Console1faSignIn"
    }
    console_authentication_failure = {
      alarm_description = "Authentication failed while trying to access the AWS console."
      alarm_name        = "Console auth failure"
      metric_name       = "ConsoleAuthFail"
    }
    iam_policy_change = {
      alarm_description = "An IAM policy changed."
      alarm_name        = "IAM policy change"
      metric_name       = "IamPolicyChange"
    }
    root_account_usage = {
      alarm_description = "The root account was used for management."
      alarm_name        = "Root account usage"
      metric_name       = "RootAccountUsage"
    }
    s3_bucket_policy_change = {
      alarm_description = "An S3 bucket policy changed."
      alarm_name        = "S3 policy change"
      metric_name       = "S3PolicyChange"
    }
    security_group_change = {
      alarm_description = "A security group changed."
      alarm_name        = "Security group change"
      metric_name       = "SecurityGroupChange"
    }
    unauthorized_api_call = {
      alarm_description = "An unauthorized call was made to an API."
      alarm_name        = "Unauthorized API call"
      metric_name       = "UnauthorizedApiCall"
    }
    vpc_gateway_change = {
      alarm_description = "A VPC gateway changed."
      alarm_name        = "VPC gateway change"
      metric_name       = "VpcGatewayChange"
    }
    vpc_nacl_change = {
      alarm_description = "A NACL changed."
      alarm_name        = "NACL change"
      metric_name       = "VpcNaclChange"
    }
    vpc_route_table_change = {
      alarm_description = "A route table changed."
      alarm_name        = "Route table change"
      metric_name       = "VpcRouteTableChange"
    }
    vpc_vpc_change = {
      alarm_description = "A VPC changed."
      alarm_name        = "VPC change"
      metric_name       = "VpcChange"
    }
  }
  alarm_action_target_sns_topic_key_list_default    = ["change_low"]
  alarm_metric_namespace_default                    = "LogMetrics"
  alarm_metric_unit_default                         = "Count"
  alarm_statistic_comparison_operator_default       = "GreaterThanThreshold"
  alarm_statistic_evaluation_period_seconds_default = 60 * 60 # Hourly "digest"
  alarm_statistic_for_metric_default                = "Sum"
  alarm_statistic_threshold_value_default           = 0
  sns_data_map                                      = module.change_topic.data
  std_map                                           = var.std_map
}
