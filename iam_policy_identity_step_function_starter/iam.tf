data "aws_iam_policy_document" "this_doc" {
  statement {
    actions = [
      "states:StartExecution",
      "states:StartSyncExecution",
    ]
    resources = [
      local.machine_arn
    ]
    sid = "StartStateMachine"
  }
}

module "this_policy" {
  source          = "../iam_policy_identity"
  iam_policy_json = data.aws_iam_policy_document.this_doc.json
  name            = var.name
  name_infix      = var.name_infix
  name_prefix     = var.name_prefix
  std_map         = var.std_map
}
