locals {
  service_resource_access_action_raw = {
    # These are the actions typically taken by services, so not creation or configuration
    # See https://docs.aws.amazon.com/service-authorization/latest/reference/reference_policies_actions-resources-contextkeys.html
    batch = {
      compute-environment = {
        public_read = []
        read = [
          "ListTagsForResource",
        ]
        public_write = []
        write = [
          "TagResource",
          "UntagResource",
        ]
      }
      job = {
        public_read = []
        read = [
          "ListTagsForResource",
        ]
        public_write = []
        write = [
          "CancelJob",
          "TagResource",
          "UntagResource",
        ]
      }
      job-definition = {
        public_read = []
        read = [
          "ListTagsForResource",
        ]
        public_write = []
        write = [
          "SubmitJob",
          "TagResource",
          "TerminateJob",
          "UntagResource",
        ]
      }
      job-queue = {
        public_read = []
        read = [
          "ListTagsForResource",
        ]
        public_write = []
        write = [
          "SubmitJob",
          "TagResource",
          "UntagResource",
        ]
      }
      #scheduling-policy
      star = {
        public_read = []
        read = [
          "DescribeComputeEnvironments",
          "DescribeJobDefinitions",
          "DescribeJobQueues",
          "DescribeJobs",
          "ListJobs",
        ]
        public_write = []
        write = [
        ]
      }
    }
    cloudfront = {
      distribution = {
        public_read = []
        read = [
          "GetDistribution",
          "GetInvalidation",
          "ListTagsForResource",
        ]
        public_write = []
        write = [
          "CreateInvalidation",
          "ListInvalidations",
          "TagResource",
          "UntagResource",
        ]
      }
      function = {
        public_read = []
        read = [
          "DescribeFunction",
        ]
        public_write = []
        write = [
          "TestFunction",
        ]
      }
      star = {
        public_read = []
        read = [
          "GetPublicKey",
          "ListDistributions",
          "ListFunctions",
          "ListPublicKeys",
          "ListStreamingDistributions",
        ]
        public_write = []
        write = [
        ]
      }
      streaming-distribution = {
        public_read = []
        read = [
          "GetStreamingDistribution",
          "ListTagsForResource",
        ]
        public_write = []
        write = [
          "TagResource",
          "UntagResource",
        ]
      }
    }
    codebuild = {
      project = {
        public_read = []
        read = [
          "BatchGetBuildBatches",
          "BatchGetBuilds",
          "BatchGetProjects",
          "ListBuildBatchesForProject",
          "ListBuildsForProject",
        ]
        public_write = []
        write = [
          "BatchDeleteBuilds",
          "DeleteBuildBatch",
          "InvalidateProjectCache",
          "RetryBuild",
          "RetryBuildBatch",
          "StartBuild",
          "StartBuildBatch",
          "StopBuild",
          "StopBuildBatch",
        ]
      }
      report_group = {
        public_read = []
        read = [
          "BatchGetReportGroups",
          "BatchGetReports",
          "DescribeCodeCoverages",
          "DescribeTestCases",
          "GetReportGroupTrend",
          "ListReportsForReportGroup",
        ]
        public_write = []
        write = [
          "BatchPutCodeCoverages",
          "BatchPutTestCases",
          "CreateReport",
          "CreateReportGroup",
          "DeleteReport",
          "DeleteReportGroup",
          "UpdateReport",
          "UpdateReportGroup",
        ]
      }
      star = {
        public_read = []
        read = [
          "ListBuildBatches",
          "ListBuilds",
          "ListProjects",
          "ListReportGroups",
          "ListReports",
          "ListSharedProjects",
          "ListSharedReportGroups",
        ]
        public_write = []
        write        = []
      }
    }
    codestar-connections = {
      connection = {
        public_read = []
        read = [
          "GetConnection",
          "ListTagsForResource",
        ]
        public_write = []
        write = [
          "PassConnection",
          "UseConnection",
        ]
      }
      host = {
        public_read = []
        read = [
          "GetHost",
        ]
        public_write = []
        write        = []
      }
      star = {
        public_read = []
        read = [
          "ListConnections",
          "ListHosts",
        ]
        public_write = []
        write = [
          "TagResource",
          "UntagResource",
        ]
      }
    }
    ecr = {
      repo = {
        public_read = []
        read = [
          "BatchCheckLayerAvailability",
          "BatchGetImage",
          "DescribeImages",
          "GetDownloadUrlForLayer",
          "ListImages",
          "ListTagsForResource",
        ]
        public_write = []
        write = [
          "BatchDeleteImage",
          "BatchImportUpstreamImage",
          "CompleteLayerUpload",
          "InitiateLayerUpload",
          "PutImage",
          "ReplicateImage",
          "TagResource",
          "UntagResource",
          "UploadLayerPart",
        ]
      }
      star = {
        public_read = []
        read = [
          "DescribeRepositories",
          "GetAuthorizationToken",
        ]
        public_write = []
        write = [
          "GetAuthorizationToken",
        ]
      }
    }
    logs = {
      group = {
        public_read = []
        read = [
          "DescribeLogStreams",
          "FilterLogEvents",
          "GetLogGroupFields",
          "ListTagsLogGroup",
          "StartQuery",
        ]
        public_write = []
        write = [
          # CreateLogGroup expressly not allowed: do not let services create goofy groups
          "TagLogGroup",
          "UntagLogGroup",
        ]
      }
      stream = {
        public_read = []
        read = [
          "GetLogEvents",
        ]
        public_write = []
        write = [
          "CreateLogStream", # Listed incorrectly in docs
          "DeleteLogStream",
          "PutLogEvents",
        ]
      }
      star = {
        public_read = []
        read = [
          "DescribeLogGroups",
          "DescribeQueries",
          "DescribeQueryDefinitions",
          "GetLogRecord",
          "GetQueryResults",
        ]
        public_write = []
        write = [
          "DeleteQueryDefinition",
          "PutQueryDefinition",
          "StopQuery",
        ]
      }
    }
    s3 = {
      bucket = {
        public_read = [
          "GetBucketLocation",
          "ListBucket",
        ]
        read = [
          "GetBucketTagging",
          "ListBucketVersions",
        ]
        public_write = [
        ]
        write = [
          "ListBucket",
          "ListBucketMultipartUploads",
          "PutBucketTagging",
        ]
      }
      object = {
        public_read = [
          "GetObject",
        ]
        read = [
          "GetObjectAcl",
          "GetObjectTagging",
          "GetObjectVersion",
          "GetObjectVersionAcl",
          "GetObjectVersionTagging",
        ]
        public_write = [
          "AbortMultipartUpload",
          "ListMultipartUploadParts",
          "PutObject",
        ]
        write = [
          "DeleteObject",
          "DeleteObjectTagging",
          "DeleteObjectVersion",
          "DeleteObjectVersionTagging",
          "PutObjectAcl",
          "PutObjectTagging",
          "PutObjectVersionAcl",
          "PutObjectVersionTagging",
          "RestoreObject",
        ]
      }
      star = {
        public_read = [
        ]
        read = [
          "GetAccessPoint",
          "ListAccessPoints",
          "ListAccessPointsForObjectLambda",
          "ListAllMyBuckets",
          "ListJobs",
          "ListMultiRegionAccessPoints",
        ]
        public_write = [
        ]
        write = [
          "CreateJob",
        ]
      }
    }
    states = {
      activity = {
        public_read = []
        read = [
          "DescribeActivity",
          "ListTagsForResource",
        ]
        public_write = []
        write = [
          #"CreateActivity",
          #"DeleteActivity",
          "GetActivityTask",
          "TagResource",
          "UntagResource",
        ]
      }
      execution = {
        public_read = []
        read = [
          "DescribeExecution",
          "DescribeStateMachineForExecution",
          "GetExecutionHistory",
        ]
        public_write = []
        write = [
          "StopExecution",
        ]
      }
      state_machine = {
        public_read = []
        read = [
          "DescribeStateMachine",
          "ListExecutions",
          "ListTagsForResource",
        ]
        public_write = []
        write = [
          #"CreateStateMachine",
          #"DeleteStateMachine",
          "StartExecution",
          "StartSyncExecution",
          "TagResource",
          "UntagResource",
          #"UpdateStateMachine",
        ]
      }
      star = {
        public_read = []
        read = [
          "ListActivities",
          "ListStateMachines",
        ]
        public_write = []
        write = [
          "SendTaskFailure",
          "SendTaskHeartbeat",
          "SendTaskSuccess",
        ]
      }
    }
    xray = {
      group = {
        public_read = []
        read = [
          "GetGroup",
          "ListTagsForResource",
        ]
        public_write = []
        write = [
          "TagResource",
          "UntagResource",
        ]
      }
      sampling_rule = {
        public_read = []
        read = [
          "ListTagsForResource",
        ]
        public_write = []
        write = [
          "TagResource",
          "UntagResource",
        ]
      }
      star = {
        public_read = []
        read = [
          "BatchGetTraces",
          "GetGroups",
          "GetInsight",
          "GetInsightEvents",
          "GetInsightImpactGraph",
          "GetInsightSummaries",
          "GetSamplingRules",
          "GetSamplingStatisticSummaries",
          "GetSamplingTargets",
          "GetServiceGraph",
          "GetTimeSeriesServiceStatistics",
          "GetTraceGraph",
          "GetTraceSummaries",
        ]
        public_write = []
        write = [
          "PutTelemetryRecords",
          "PutTraceSegments",
        ]
      }
    }
  }
}
