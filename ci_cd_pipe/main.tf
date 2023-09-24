resource "aws_codepipeline" "this_pipeline" {
  for_each = local.pipe_map
  artifact_store {
    # encryption_key # TODO: default
    location = var.ci_cd_account_data.bucket.name_effective
    type     = "S3"
  }
  role_arn = each.value.iam_role_arn
  name     = each.value.name_effective
  stage {
    action {
      category = "Source"
      name     = "Source"
      configuration = {
        BranchName           = each.value.source_branch
        ConnectionArn        = var.ci_cd_account_data.code_star.connection[each.value.source_connection_name].arn
        DetectChanges        = each.value.source_detect_changes
        FullRepositoryId     = each.value.source_repository_id
        OutputArtifactFormat = "CODE_ZIP"
      }
      input_artifacts = []
      output_artifacts = [
        "SourceArtifact",
      ]
      owner     = "AWS"
      namespace = "SourceSource"
      region    = var.std_map.aws_region_name
      provider  = "CodeStarSourceConnection"
      run_order = 1
      version   = "1"
    }
    name = "Source"
  }
  dynamic "stage" {
    for_each = each.value.stage_list
    content {
      dynamic "action" {
        for_each = stage.value.action_map
        content {
          category         = action.value.category
          configuration    = action.value.configuration
          input_artifacts  = action.value.input_artifact_list
          name             = action.value.name
          output_artifacts = action.value.output_artifact_list
          owner            = action.value.owner
          namespace        = "${stage.value.name}${action.value.name}"
          provider         = action.value.provider
          region           = var.std_map.aws_region_name
          role_arn         = action.value.iam_role_arn
          run_order        = 1
          version          = action.value.version
        }
      }
      name = stage.value.name
    }
  }
  tags = each.value.tags
}
