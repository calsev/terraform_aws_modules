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
    bedrock = {
      agent = {
        public_read = []
        read = [
          "GetAgent",
          "GetAgentActionGroup",
          "GetAgentKnowledgeBase",
          "GetAgentVersion",
          "ListAgentActionGroups",
          "ListAgentAliases",
          "ListAgentKnowledgeBases",
          "ListAgentVersions",
          "ListTagsForResource",
        ]
        public_write = []
        write = [
          "TagResource",
          "UntagResource",
        ]
      }
      agent-alias = {
        public_read = []
        read = [
          "GetAgentAlias",
          "GetAgentMemory",
          "ListTagsForResource",
        ]
        public_write = []
        write = [
          "InvokeAgent",
          "TagResource",
          "UntagResource",
        ]
      }
      application-inference-profile = {
        public_read = []
        read = [
          "GetInferenceProfile",
          "ListTagsForResource",
        ]
        public_write = []
        write = [
          "InvokeModel",
          "InvokeModelWithResponseStream",
          "TagResource",
          "UntagResource",
        ]
      }
      custom-model = {
        public_read = []
        read = [
          "GetCustomModel",
          "ListTagsForResource",
        ]
        public_write = []
        write = [
          "CreateEvaluationJob",
          "CreateModelCustomizationJob",
          "CreateModelEvaluationJob",
          "CreateModelInvocationJob",
          "TagResource",
          "UntagResource",
        ]
      }
      evaluation-job = {
        public_read = []
        read = [
          "GetEvaluationJob",
          "ListTagsForResource",
        ]
        public_write = []
        write = [
          "StopEvaluationJob",
          "TagResource",
          "UntagResource",
        ]
      }
      foundation-model = {
        public_read = []
        read = [
          "GetFoundationModel",
        ]
        public_write = []
        write = [
          "CreateEvaluationJob",
          "CreateModelCustomizationJob",
          "CreateModelEvaluationJob",
          "CreateModelInvocationJob",
          "DetectGeneratedContent",
          "InvokeModel",
          "InvokeModelWithResponseStream",
        ]
      }
      inference-profile = {
        public_read = []
        read = [
          "GetInferenceProfile",
        ]
        public_write = []
        write = [
          "InvokeModel",
          "InvokeModelWithResponseStream",
        ]
      }
      model-customization-job = {
        public_read = []
        read = [
          "GetModelCustomizationJob",
          "ListTagsForResource",
        ]
        public_write = []
        write = [
          "StopModelCustomizationJob",
          "TagResource",
          "UntagResource",
        ]
      }
      model-evaluation-job = {
        public_read = []
        read = [
          "GetModelEvaluationJob",
          "ListTagsForResource",
        ]
        public_write = []
        write = [
          "TagResource",
          "UntagResource",
        ]
      }
      model-invocation-job = {
        public_read = []
        read = [
          "GetModelInvocationJob",
          "ListTagsForResource",
        ]
        public_write = []
        write = [
          "StopModelInvocationJob",
          "TagResource",
          "UntagResource",
        ]
      }
      provisioned-model = {
        public_read = []
        read = [
          "ListTagsForResource",
        ]
        public_write = []
        write = [
          "InvokeModel",
          "InvokeModelWithResponseStream",
          "TagResource",
          "UntagResource",
        ]
      }
      star = {
        public_read = []
        read = [
          "ListAgents",
        ]
        public_write = []
        write        = []
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
    codedeploy = {
      application = {
        public_read = []
        read = [
          "BatchGetApplicationRevisions",
          "BatchGetApplications",
          "GetApplication",
          "GetApplicationRevision",
          "ListApplicationRevisions",
          "ListDeploymentGroups",
          "ListTagsForResource",
        ]
        public_write = []
        write = [
          "RegisterApplicationRevision",
          "TagResource",
          "UntagResource",
        ]
      }
      deploymentconfig = {
        public_read = []
        read = [
          "GetDeploymentConfig",
        ]
        public_write = []
        write        = []
      }
      deploymentgroup = {
        public_read = []
        read = [
          "BatchGetDeploymentGroups",
          "BatchGetDeploymentInstances",
          "BatchGetDeployments",
          "GetDeployment",
          "GetDeploymentGroup",
          "GetDeploymentInstance",
          "ListDeploymentInstances",
          "ListDeployments",
          "ListTagsForResource",
        ]
        public_write = []
        write = [
          "CreateDeployment",
          "TagResource",
          "UntagResource",
        ]
      }
      instance = {
        public_read = []
        read = [
          "BatchGetOnPremisesInstances",
          "GetOnPremisesInstance",
        ]
        public_write = []
        write = [
          "AddTagsToOnPremisesInstances",
          "RegisterOnPremisesInstance",
          "RemoveTagsFromOnPremisesInstances",
        ]
      }
      star = {
        public_read = []
        read = [
          "BatchGetDeploymentTargets",
          "GetDeploymentTarget",
          "ListApplications",
          "ListDeploymentConfigs",
          "ListDeploymentTargets",
          # "ListGitHubAccountTokenNames",
          "ListOnPremisesInstances",
        ]
        public_write = []
        write = [
          "ContinueDeployment",
          "CreateCloudFormationDeployment",
          "PutLifecycleEventHookExecutionStatus",
          "SkipWaitTimeForInstanceTermination",
          "StopDeployment",
        ]
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
    dynamodb = {
      global-table = {
        public_read = []
        read = [
          "DescribeGlobalTable",
        ]
        public_write = []
        write        = []
      }
      import = {
        public_read = []
        read = [
          "DescribeImport",
        ]
        public_write = []
        write        = []
      }
      index = {
        public_read = []
        read = [
          "PartiQLInsert",
          "Query",
          "Scan",
        ]
        public_write = []
        write        = []
      }
      star = {
        public_read = []
        read = [
          "DescribeEndpoints",
          "ListGlobalTables",
          "ListStreams",
          "ListTables",
        ]
        public_write = []
        write        = []
      }
      stream = {
        public_read = []
        read = [
          "GetRecords",
          "GetShardIterator",
        ]
        public_write = []
        write        = []
      }
      table = {
        public_read = []
        read = [
          "BatchGetItem",
          "ConditionCheckItem",
          "DescribeExport",
          "DescribeTable",
          "GetItem",
          "ListTagsOfResource",
          "Query",
          "Scan",
        ]
        public_write = []
        write = [
          "BatchWriteItem",
          "DeleteItem",
          "ExportTableToPointInTime",
          "ImportTable",
          "PartiQLDelete",
          "PartiQLInsert",
          "PartiQLUpdate",
          "PutItem",
          "RestoreTableToPointInTime",
          "TagResource",
          "UntagResource",
          "UpdateItem",
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
    ecs = {
      capacity-provider = {
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
      cluster = {
        public_read = []
        read = [
          "ListContainerInstances",
          "ListTagsForResource",
        ]
        public_write = []
        write = [
          "DeregisterContainerInstance",
          "RegisterContainerInstance",
          "TagResource",
          "UntagResource",
        ]
      }
      container-instance = {
        public_read = []
        read = [
          "ListTagsForResource",
          "ListTasks",
        ]
        public_write = []
        write = [
          "StartTelemetrySession",
          "TagResource",
          "UntagResource",
        ]
      }
      service = {
        public_read = []
        read = [
          "ListTagsForResource",
        ]
        public_write = []
        write = [
          "TagResource",
          "UntagResource",
          "UpdateService",
          "UpdateServicePrimaryTaskSet",
        ]
      }
      star = {
        public_read = []
        read = [
        ]
        public_write = []
        write = [
        ]
      }
      task = {
        public_read = []
        read = [
          "ListTagsForResource",
        ]
        public_write = []
        write = [
          "StopTask",
          "TagResource",
          "UntagResource",
        ]
      }
      task-definition = {
        public_read = []
        read = [
          "ListTagsForResource",
        ]
        public_write = []
        write = [
          "RunTask",
          "StartTask",
          "TagResource",
          "UntagResource",
        ]
      }
      task-set = {
        public_read = []
        read = [
          "ListTagsForResource",
        ]
        public_write = []
        write = [
          "TagResource",
          "UntagResource",
          "UpdateTaskSet",
        ]
      }
    }
    elasticfilesystem = {
      access-point = {
        public_read = []
        read = [
          "DescribeAccessPoints",
          "ListTagsForResource",
        ]
        public_write = []
        write = [
          "TagResource",
          "UntagResource",
        ]
      }
      file-system = {
        public_read = []
        read = [
          "ClientMount",
          "DescribeFileSystems",
          "DescribeMountTargets",
          "DescribeTags",
          "ListTagsForResource",
        ]
        public_write = []
        write = [
          "ClientRootAccess", # Needed to delete files owned by root
          "ClientWrite",
          "DeleteTags",
          "TagResource",
          "UntagResource",
        ]
      }
    }
    events = {
      api-destination = {
        public_read = []
        read = [
        ]
        public_write = []
        write = [
          "InvokeApiDestination",
        ]
      }
      event-bus = {
        public_read = []
        read = [
          "ListTagsForResource",
        ]
        public_write = []
        write = [
          "PutEvents",
          "TagResource",
          "UntagResource",
        ]
      }
      star = {
        public_read = []
        read = [
          "ListApiDestinations",
          "ListEventBuses",
        ]
        public_write = []
        write = [
        ]
      }
    }
    kms = {
      alias = {
        public_read  = []
        read         = []
        public_write = []
        write        = []
      }
      key = {
        public_read = []
        read = [
          "DescribeKey", # Required for encryption
          "GetPublicKey",
          "ListResourceTags",
        ]
        public_write = []
        write = [
          "Decrypt",
          "Encrypt",
          "GenerateDataKey", # Required for encryption
          "GenerateMac",
          "ReEncryptFrom",
          "ReEncryptTo",
          "Sign",
          "TagResource",
          "UntagResource",
          "Verify",
          "VerifyMac",
        ]
      }
      star = {
        public_read = []
        read = [
          "ListAliases",
          "ListKeys",
        ]
        public_write = []
        write = [
          "GenerateRandom",
        ]
      }
    }
    lambda = {
      function = {
        public_read = []
        read = [
          "ListTags",
        ]
        public_write = []
        write = [
          "InvokeFunction",
          "InvokeFunctionUrl",
          "TagResource",
          "UntagResource",
        ]
      }
      star = {
        public_read = []
        read = [
          "ListFunctions",
        ]
        public_write = []
        write = [
        ]
      }
    }
    logs = {
      group = {
        public_read = [
          "DescribeLogStreams",
        ]
        read = [
          "FilterLogEvents",
          "GetLogGroupFields",
          "GetLogRecord",
          "GetQueryResults",
          "ListTagsForResource",
          "ListTagsLogGroup",
          "StartQuery",
        ]
        public_write = []
        write = [
          # CreateLogGroup expressly not allowed: do not let services create goofy groups
          "TagLogGroup",
          "TagResource",
          "UntagLogGroup",
          "UntagResource",
        ]
      }
      stream = {
        public_read = [
          "GetLogEvents",
        ]
        read         = []
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
          "DescribeQueryDefinitions",
          "DescribeQueries",
          "StopQuery",
        ]
        public_write = []
        write        = []
      }
    }
    mobileanalytics = {
      star = {
        public_read  = []
        read         = []
        public_write = []
        write = [
          "PutEvents",
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
          "GetObjectVersion",
        ]
        read = [
          # "GetObjectAcl",
          "GetObjectTagging",
          # "GetObjectVersionAcl",
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
          # "PutObjectAcl",
          "PutObjectTagging",
          # "PutObjectVersionAcl",
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
    secretsmanager = {
      secret = {
        public_read = []
        read = [
          "DescribeSecret",
          "GetSecretValue",
          "ListSecretVersionIds",
        ]
        public_write = []
        write = [
          "CancelRotateSecret",
          "PutSecretValue",
          "RotateSecret",
          "TagResource",
          "UntagResource",
          "UpdateSecret",
          "UpdateSecretVersionStage",
        ]
      }
      star = {
        public_read = []
        read = [
          # "BatchGetSecretValue",
          "GetRandomPassword",
          "ListSecrets",
        ]
        public_write = []
        write        = []
      }
    }
    sns = {
      topic = {
        public_read = []
        read = [
          "ListTagsForResource",
        ]
        public_write = []
        write = [
          "Publish",
          "TagResource",
          "UntagResource",
        ]
      }
    }
    sqs = {
      queue = {
        public_read = []
        read = [
          "GetQueueAttributes",
          "GetQueueUrl",
          "ListQueueTags",
        ]
        public_write = []
        write = [
          "DeleteMessage",
          "PurgeQueue",
          "ReceiveMessage",
          "SendMessage",
          "TagQueue",
          "UntagQueue",
        ]
      }
      star = {
        public_read = []
        read = [
          "ListQueues",
        ]
        public_write = []
        write        = []
      }
    }
    ssm = {
      parameter = {
        public_read = []
        read = [
          "GetParameter",
          "GetParameters",
          "GetParametersByPath",
          "ListTagsForResource",
        ]
        public_write = []
        write = [
          "AddTagsToResource",
          "LabelParameterVersion",
          "RemoveTagsFromResource",
          "UnlabelParameterVersion",
        ]
      }
      star = {
        public_read = []
        read = [
          "DescribeParameters",
        ]
        public_write = []
        write        = []
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
